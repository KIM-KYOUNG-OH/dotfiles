# CS-RAG 문서화 계획

## 목표
Java 개발자가 이해할 수 있는 3개 문서 작성 + README 개선

## 대상 독자
- Java 개발자 (Python RAG 프로젝트를 처음 접하는 사람)
- 학습 목적 + 인수인계 목적 겸용

## 문서 언어: 한국어

---

## 생성/수정 파일

### 1. `docs/development-guide.md` - 개발 과정 가이드 (신규)

**구성:**
1. **프로젝트 개요** - 왜 만들었는지, 무엇을 하는지 (requirements.md 내용 기반)
2. **아키텍처 설명** - 4개 모듈(collector, indexer, rag, cli) 역할과 데이터 흐름
   - 설계 문서(2025-01-28-cs-rag-design.md)의 ASCII 아키텍처 다이어그램 활용
   - 각 모듈의 핵심 클래스와 책임
3. **개발 과정 재현** - git log 기반 5단계 Phase별 진행 과정
   - Phase 1: Foundation (프로젝트 구조, 설정, CLI 스켈레톤)
   - Phase 2: Indexing Pipeline (파서 → 임베더 → 벡터스토어 → 파이프라인)
   - Phase 3: Retriever (벡터 검색 → search CLI)
   - Phase 4: RAG Generator (Bedrock 클라이언트 → 프롬프트 빌더 → Generator → ask CLI)
   - Phase 5: Data Collection (Graph API → Models → Parser → Service → collect CLI)
   - 각 Phase별 주요 커밋과 TDD Red-Green 흐름 설명
4. **TDD + Claude Code 활용법** - 이 프로젝트가 Claude Code와 TDD로 어떻게 만들어졌는지
   - 커밋 메시지의 "Co-Authored-By: Claude" 패턴
   - Phase별 plan 문서를 먼저 작성하고 구현한 방식

### 2. `docs/usage-guide.md` - 사용법 문서 (신규)

**구성:**
1. **사전 요구사항** - Python 3.11+, uv 또는 pip
2. **설치 방법** - uv sync / pip install -e ".[dev]"
3. **환경변수 설정** - .env 파일 전체 예시 (Azure, Teams, AWS 모두)
4. **CLI 명령어 상세**
   - `cs-rag collect [--date YYYY-MM-DD]` - Teams 데이터 수집
   - `cs-rag index` - 인덱싱
   - `cs-rag search "키워드"` - LLM 없이 벡터 검색
   - `cs-rag ask "질문"` - RAG 질의 응답
   - `cs-rag --version` / `cs-rag --help`
5. **전체 워크플로우 예시** - 처음 설치부터 질문까지 일련의 흐름
6. **트러블슈팅** - 인덱스 없음, 인증 실패, Bedrock 연결 실패 등

### 3. `docs/teams-api-guide.md` - Teams API 연동 가이드 (신규)

**구성:**
1. **개요** - Microsoft Graph API를 통한 Teams 채널 메시지 수집
2. **Azure AD 앱 등록** - 단계별 절차
   - Azure Portal 접속 → App registrations → New registration
   - Client Secret 생성
   - API Permissions 설정 (ChannelMessage.Read.All, Team.ReadBasic.All)
   - Admin Consent 부여
3. **Teams Team ID / Channel ID 확인** - Graph Explorer나 Teams URL에서 추출
4. **인증 흐름 설명** - Client Credentials Flow (앱 전용)
   - MSAL 라이브러리를 사용한 토큰 획득
   - GraphClient 클래스의 인증 코드 해설
5. **API 호출 흐름** - 메시지 조회 → 답글 조회 → 마크다운 변환
   - 코드 수준 설명 (graph_client.py, service.py, parser.py)
   - Graph API endpoint 정리 (/teams/{id}/channels/{id}/messages)
6. **환경변수 설정** - .env 파일 예시
7. **흔한 에러와 해결법** - 인증 실패, 권한 부족, 메시지 없음 등

### 4. `README.md` - 개선 (수정)

**현재 상태:** 5줄밖에 없음 (설치 + cs-rag version만)

**개선 내용:**
- 프로젝트 한 줄 설명
- 핵심 기능 4가지 요약
- Quick Start (설치 → 인덱싱 → 검색)
- 상세 문서 링크 (docs/ 문서 3개로 연결)
- 기술 스택 표
- 프로젝트 구조 트리

---

## 작업 순서

1. `docs/development-guide.md` 작성
2. `docs/usage-guide.md` 작성
3. `docs/teams-api-guide.md` 작성
4. `README.md` 개선

## 검증 방법
- 각 문서의 코드 예시가 실제 소스와 일치하는지 확인
- 링크 연결이 올바른지 확인
- CLI 명령어 예시가 실제 동작과 일치하는지 확인
