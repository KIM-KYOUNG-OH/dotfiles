# Teams 링크 및 첨부 파일 추가 구현 계획

## 목표
Teams 메시지 수집 시 마크다운 문서에 (1) Teams 딥링크, (2) 첨부 파일 링크를 추가한다.

## 최종 출력 형태

```markdown
## CS-001 [10:23] 홍길동 [[Teams에서 보기](https://teams.microsoft.com/...)]
**문의**: 로그인 시 "세션 만료" 오류 발생

**첨부**: [에러화면.png](https://...), [로그파일.txt](https://...)

### 답글
- [10:45] 김개발: 캐시 삭제 후 재시도 요청 [📎 가이드.pdf](https://...)
```

## 변경 파일 및 작업

### Step 1: 모델 확장 (`src/collector/models.py`)
- `TeamsAttachment` dataclass 추가: `name: str`, `content_url: str`
- `TeamsReply`에 `attachments: list[TeamsAttachment]` 필드 추가 (default=[])
- `TeamsMessage`에 `attachments: list[TeamsAttachment]`, `web_url: str | None` 필드 추가

### Step 2: Graph API 파싱 확장 (`src/collector/graph_client.py`)
- `_parse_attachments(attachments_data)` 메서드 추가
  - `item["attachments"]` 배열에서 `name`, `contentUrl` 추출
  - `contentType`이 `reference`인 파일 첨부만 포함 (카드/어댑티브 카드 제외)
- `_parse_message()`에서 `webUrl` 필드 추출 → `TeamsMessage.web_url`
- `_parse_message()`에서 `attachments` 필드 추출 → `TeamsMessage.attachments`
- `_parse_reply()`에서 `attachments` 필드 추출 → `TeamsReply.attachments`

### Step 3: 마크다운 출력 변경 (`src/collector/parser.py`)
- 메시지 헤더에 Teams 링크 추가: `## CS-001 [10:23] 홍길동 [[Teams에서 보기](url)]`
  - `web_url`이 None이면 링크 생략
- 문의 본문 아래에 첨부 파일 목록 추가: `**첨부**: [파일명](url), ...`
  - 첨부가 없으면 해당 줄 생략
- 답글 끝에 첨부 파일 링크 추가: `[📎 파일명](url)`
  - 답글에 첨부가 없으면 생략

### Step 4: 테스트 업데이트

#### `tests/unit/test_collector.py`
- `TestTeamsMessage`: 새 필드(attachments, web_url) 포함 테스트 추가
- `TestGraphClientMessages`: mock Graph API 응답에 `webUrl`, `attachments` 포함
- `TestTeamsMessageParser`:
  - Teams 링크가 헤더에 포함되는지 검증
  - 첨부 파일이 본문 아래에 표시되는지 검증
  - 답글 첨부 파일 표시 검증
  - web_url이 None일 때 링크 생략 검증
  - 첨부 없을 때 첨부 줄 생략 검증
- 기존 테스트는 새 필드 기본값으로 호환 (하위호환성 유지)

## Graph API 참고
- `webUrl`: 메시지 객체의 최상위 필드, Teams 클라이언트 딥링크
- `attachments`: `chatMessageAttachment[]` 배열
  - `contentType: "reference"` → 파일 첨부 (SharePoint URL)
  - `contentUrl` → 파일 접근 URL
  - `name` → 파일명

## 검증 방법
1. `pytest tests/unit/test_collector.py` — 단위 테스트 통과
2. `pytest` — 전체 테스트 회귀 없음 확인
3. (선택) `cs-rag collect --date YYYY-MM-DD` 실행하여 실제 마크다운 출력 확인
