---
name: obsidian-document-policy
description: Obsidian vault 문서 저장 통합 정책. skill에서 필요 시 Read 도구로 명시적 참조.
type: policy
---

# Obsidian Document Policy

Obsidian vault 문서 저장 시 적용하는 통합 정책.

## 1. 디렉토리 구조 및 저장 경로

### Vault Root

```
~/OneDrive/my-obsidian-vault/
```

### Zettelkasten 폴더 구조

| 폴더 | 용도 | 작업 권한 | 저장 대상 |
|------|------|-----------|-----------|
| **000-SLIPBOX** | 개인 인사이트, 영구 노트 | 읽기/쓰기 | 개인 생각, 연결된 아이디어 |
| **001-INBOX** | 수집함, 임시 노트 | 읽기/쓰기 | 빠른 메모, 처리 전 자료 |
| **002-PROJECTS** | 프로젝트 문서 | 읽기/쓰기 | Bug Report, QA Doc, Tech Guide |
| **003-RESOURCES** | 참고자료, 학습 자료 | 주로 읽기 | 외부 문서, 북마크, 아티클 |
| **archive** | 보관 자료 | ⛔ **접근 금지** | 완료된 프로젝트, 오래된 자료 |

### 문서 타입별 저장 위치

| 문서 타입 | 저장 디렉토리 | 예시 |
|-----------|---------------|------|
| Bug Report | `002-PROJECTS/{프로젝트명}/` | `002-PROJECTS/my-app/bug-report-*.md` |
| QA Document | `002-PROJECTS/{프로젝트명}/` | `002-PROJECTS/payment-api/qa-*.md` |
| Technical Guide | `002-PROJECTS/{프로젝트명}/` | `002-PROJECTS/platform/redis-caching.md` |
| 외부 아티클 요약 | `003-RESOURCES/` | `003-RESOURCES/kubernetes-patterns.md` |
| YouTube 요약 | `003-RESOURCES/` | `003-RESOURCES/tdd-tutorial.md` |
| 개인 인사이트 | `000-SLIPBOX/` | `000-SLIPBOX/architecture-thoughts.md` |
| 임시 메모 | `001-INBOX/` | `001-INBOX/quick-note.md` |

### 제외 대상 (작업 금지)

| 대상 | 이유 |
|------|------|
| `.obsidian/` | Obsidian 설정 폴더 |
| `archive/` | 보관 자료 (변경 금지) |
| `.canvas` 파일 | Canvas 형식 (텍스트 아님) |
| 이미지 파일 | `.png`, `.jpg`, `.gif` 등 |

### 프로젝트명 규칙

- **형식**: 소문자 + 하이픈
- **예시**: `my-app`, `data-pipeline`, `payment-api`
- **저장 시**: 사용자에게 프로젝트명 확인 필수

## 2. Hierarchical Tags 체계

### 태그 형식

```
#category/subcategory/detail
```

### 태그 명명 규칙 (필수)

| 규칙 | 예시 | 금지 |
|------|------|------|
| **소문자만** | `#backend/api` | ~~`#Backend/API`~~ |
| **'-' 사용** | `#spring-boot` | ~~`#spring boot`~~ |
| **'/' 계층** | `#topic/backend` | ~~`#topic.backend`~~ |
| **의미 중심** | `#git/worktree` | ~~`#resources/git`~~ (디렉토리 기반 금지) |
| **prefix 생략** | `#tdd` | ~~`#development/tdd`~~ (대부분 개발 관련이므로 불필요) |

### 태그 개수 제한

- **권장**: 8-12개 (Graph View 최적화)
- **최대**: 15개
- **최소**: 3개

### 태그 선택 기준

1. **주요 주제 대표**: 문서의 핵심 개념
2. **연결 가능성**: 다른 문서와 링크될 가능성이 높은 태그
3. **계층 다양성**: 다양한 레벨의 태그 포함

### 5가지 주요 카테고리

#### 1. Topic (주제/기술)

```yaml
tags:
  - topic/backend/api
  - topic/frontend/react
  - topic/devops/kubernetes
  - topic/database/postgresql
  - topic/ai/llm
```

**확장 예시**:
```yaml
# 프로그래밍 언어
- topic/java/spring
- topic/python/django
- topic/typescript/react

# 아키텍처
- topic/architecture/microservices
- topic/architecture/hexagonal
- topic/architecture/event-driven

# 방법론
- topic/tdd/unit-testing
- topic/ddd/aggregates
- topic/refactoring/patterns
```

#### 2. Document Type (문서 유형)

```yaml
tags:
  - doctype/bug-report
  - doctype/qa-document
  - doctype/technical-guide
  - doctype/architecture
  - doctype/meeting-minutes
  - doctype/tutorial
  - doctype/reference
```

#### 3. Source (출처)

```yaml
tags:
  - source/internal         # 내부 작성
  - source/external         # 외부 자료
  - source/ai-generated     # AI 생성
  - source/book            # 도서
  - source/article         # 아티클
  - source/video           # 영상
  - source/conference      # 컨퍼런스
```

#### 4. Status (상태)

```yaml
tags:
  - status/draft           # 초안
  - status/in-progress     # 진행 중
  - status/review          # 검토 중
  - status/published       # 발행됨
  - status/archived        # 보관됨
```

#### 5. Project (프로젝트)

```yaml
tags:
  - project/my-app
  - project/data-pipeline
  - project/mobile-app
```

### 태그 설계 원칙

1. **디렉토리 기반 태그 금지**
   - ❌ `#resources/git`, `#slipbox/architecture`
   - ✅ `#git/features`, `#architecture/patterns`

2. **의미 중심 태그 사용**
   - ❌ `#development/backend/api` (prefix 불필요)
   - ✅ `#backend/api/rest`

3. **Graph View 최적화**
   - 너무 세분화 지양 (연결성 고려)
   - 일관성 유지 (동일 주제 = 동일 구조)
   - 단수/복수 통일

4. **태그 재사용성**
   - 여러 문서에서 공통으로 사용 가능한 태그
   - 지나치게 특정 문서에만 적용되는 태그 지양

## 3. Frontmatter 구조

### 공통 필수 필드

```yaml
---
type: {문서타입}                    # bug-report, qa-document 등
project: {프로젝트명}               # my-app, data-pipeline 등
date: {YYYY-MM-DD}                 # 생성 날짜
tags:                              # Hierarchical Tags (8-12개 권장)
  - doctype/{타입}
  - topic/{주제}
  - status/{상태}
  - project/{프로젝트명}
  - source/{출처}
---
```

### Author 필드 규칙

```yaml
# 사람 이름은 소문자 + 하이픈
author: ian-cooper              # ✅
author: Ian Cooper              # ❌

# 여러 저자
authors:
  - martin-fowler
  - kent-beck
```

### 문서 타입별 추가 필드

**Bug Report**:
```yaml
severity: {Critical|High|Medium|Low}
status: {New|In Progress|Resolved|Closed}
```

**QA Document**:
```yaml
test-date: {YYYY-MM-DD}
tester: {테스터 이름}
```

**Technical Guide**:
```yaml
topic: {주제}
purpose: {목적}
audience: {대상 독자}
```

## 4. 파일명 규칙

### 기본 형식

```
{타입}-{YYYY-MM-DD_HH-mm}.md       # 타임스탬프 기반
{의미있는-이름}.md                  # 사용자 지정
```

### 명명 규칙

| 규칙 | 설명 | 예시 |
|------|------|------|
| **소문자** | 모든 문자 소문자 | `api-guide.md` |
| **하이픈** | 단어 구분 | `rest-api-design.md` |
| **영문만** | 한글 금지 | ~~`버그리포트.md`~~ |
| **특수문자 금지** | 알파벳, 숫자, `-` 만 | ~~`api_guide.md`~~ |
| **최대 50자** | 간결성 유지 | - |

**좋은 예시**:
- `redis-caching-guide.md`
- `microservices-architecture.md`
- `bug-report-2026-02-11_14-30.md`

**나쁜 예시**:
- ~~`API Guide.md`~~ (공백, 대문자)
- ~~`api_guide.md`~~ (언더스코어)
- ~~`가이드.md`~~ (한글)

### 타입별 파일명

| 타입 | 형식 | 예시 |
|------|------|------|
| Bug Report | `bug-report-{timestamp}.md` | `bug-report-2026-02-11_14-30.md` |
| QA Document | `qa-{timestamp}.md` | `qa-2026-02-11_14-30.md` |
| Tech Guide | `{주제}.md` | `kubernetes-deployment.md` |

## 5. Severity & Status 정의

### Severity (심각도)

| Level | 의미 | 적용 문서 |
|-------|------|-----------|
| **Critical** | 시스템 전체 작동 불가, 데이터 손실 위험 | Bug Report, QA |
| **High** | 주요 기능 작동 불가, 다수 사용자 영향 | Bug Report, QA |
| **Medium** | 일부 기능 오작동, 우회 방법 존재 | Bug Report, QA |
| **Low** | 사소한 문제, 경미한 불편 | Bug Report, QA |

### Status (상태)

| Status | 의미 | 다음 단계 |
|--------|------|-----------|
| **Draft** | 초안 작성 중 | Review |
| **In Progress** | 작업 진행 중 | Completed |
| **Review** | 검토 요청됨 | Published |
| **Completed** | 작업 완료 | Published/Archived |
| **Published** | 공개/배포됨 | Archived |
| **New** | 새로 생성됨 | In Progress |
| **Resolved** | 해결됨 (버그/이슈) | Closed |
| **Closed** | 종료됨 | - |

## 6. 작성 원칙

### CLEAR 원칙

| 원칙 | 설명 |
|------|------|
| **C**larity | 명확하고 구체적인 용어 사용 |
| **L**ink | Wiki-link `[[]]`로 관련 노트 연결 |
| **E**vidence | 근거 제시 (코드, 로그, 스크린샷) |
| **A**ccessibility | 문서만으로 이해 가능하도록 |
| **R**eusability | 재사용 가능한 구조 |

### 스타일 가이드

**제목 작성**:
- 형식: 명확하고 구체적으로
- ✅ "Redis 캐싱 전략 가이드"
- ❌ "기술 문서" (너무 일반적)

**코드 블록**:
````markdown
```language
실행 가능한 코드
```
````

**링크**:
- Wiki-link: `[[다른 노트]]`
- 외부 링크: `[제목](URL)`

## 7. 참조 방법

이 정책을 참조하는 스킬들은 다음과 같이 명시적으로 파일을 읽어야 합니다:

```
Read 도구로 ~/.claude/policies/obsidian-document-policy.md 를 읽어 정책을 확인
```

**참조하는 스킬들:**
- `issue-bug-report`: 버그 리포트 생성
- `issue-qa-doc`: QA 문서 생성
- `issue-tech-doc-guide`: 기술 문서 생성
- `obsidian:add-tag`: 태그 자동 부여
- `obsidian:add-tag-and-move-file`: 태그 + 파일 이동
- `obsidian:summarize-article`: 기술 문서 요약
- `obsidian:summarize-youtube`: YouTube 영상 요약
- `obsidian:batch-summarize-urls`: URL 일괄 요약
- (향후 추가될 모든 Obsidian 저장 스킬)

## 8. 실제 적용 예시

### 버그 리포트

```yaml
---
type: bug-report
project: payment-api
date: 2026-02-11
severity: High
status: In Progress
author: john-doe
tags:
  - doctype/bug-report
  - topic/backend/api
  - topic/payment/processing
  - status/in-progress
  - project/payment-api
  - source/internal
---
```

### 기술 가이드

```yaml
---
type: technical-guide
project: microservices-platform
date: 2026-02-11
topic: kubernetes deployment
audience: developers
status: Published
author: jane-smith
tags:
  - doctype/technical-guide
  - topic/devops/kubernetes
  - topic/deployment/automation
  - status/published
  - project/microservices-platform
  - source/internal
---
```

## 9. 정책 업데이트

이 정책 변경 시:
- ✅ 이 스킬만 수정
- ✅ 참조 스킬들에 자동 반영
- ✅ 일관성 유지

---

**버전**: 1.1.0
**최종 수정**: 2026-02-11
**관리**: .claude/policies/obsidian-document-policy.md
