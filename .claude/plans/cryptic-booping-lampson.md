# collect 명령어 개선 계획

## 요구사항

1. `--date` 없이 실행: 채널의 **모든 메시지**를 가져와 날짜별로 그룹핑하여 **어제까지** 파일 생성
2. `--date YYYY-MM-DD`: 해당 날짜만 수집 (기존 동작 유지 + 개선)
3. 기존 파일은 덮어쓰기
4. 페이지네이션(`@odata.nextLink`) 지원
5. `$expand=replies`로 인라인 답글 조회 (N+1 제거)

## 변경 파일 및 순서

### Step 1: `src/collector/graph_client.py`

- **`get_all_channel_messages(team_id, channel_id)` 추가**: 페이지네이션 + `$expand=replies&$top=50`
- **`_parse_inline_replies(replies_data)` 추가**: 인라인 replies 파싱
- **`get_channel_messages(date)` 변경**: 내부에서 `get_all_channel_messages()` 호출 후 날짜 필터링

### Step 2: `src/collector/service.py`

- **`collect_all()` 메서드 추가**: 전체 메시지 조회 → 날짜별 그룹핑(어제까지) → 각 날짜별 마크다운 파일 저장 → `list[Path]` 반환
- 기존 `collect(date)` 유지

### Step 3: `src/cli/main.py`

- `--date` 없으면 `service.collect_all()` 호출, 결과 개수 출력
- `--date` 있으면 기존대로 `service.collect(date)` 호출

### Step 4: 테스트 업데이트

- 기존 mock 구조를 `$expand=replies` 방식으로 변경 (답글이 메시지 JSON 안에 포함)
- 페이지네이션, collect_all 관련 테스트 추가

## 검증 방법

1. `uv run cs-rag collect` → 어제까지의 날짜별 파일 생성 확인
2. `uv run cs-rag collect --date 2026-01-28` → 특정 날짜 파일 생성 확인
3. 기존 테스트 통과 확인
