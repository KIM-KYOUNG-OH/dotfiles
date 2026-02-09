# 고립 태그 정리 계획

## Context
`analyze-gaps` 결과 7,810개의 고립 태그(1개 문서에만 존재하는 태그) 발견. 해시값, 섹션번호, 코드식별자, 과잉 계층 태그 등이 포함되어 분류 기능을 하지 못함. CLI 명령어로 추가하여 재사용 가능하게 구현.

## 구현 계획

### Step 1: `clean-tags` CLI 명령어 추가 (`src/__main__.py`)
- `clean-tags` 서브커맨드 추가
- 옵션: `--dry-run` (미리보기), `--top-k` (표시할 결과 수)
- `run_clean_tags()` 함수 구현

### Step 2: `clean_isolated_tags()` 함수 추가 (`src/features/advanced_search.py`)
- `analyze_knowledge_gaps()`에서 고립 태그 목록 가져오기
- 파일별로 제거할 태그 그룹핑: `{file_path: [tag1, tag2, ...]}`
- 각 파일의 frontmatter에서 해당 태그만 제거 (다른 태그는 유지)
- dry_run 모드: 변경 내용만 출력, 파일 수정 안 함
- 처리 결과 통계 반환

### Step 3: frontmatter 태그 제거 헬퍼 (`src/core/vault_processor.py`)
- `remove_tags_from_file(file_path, tags_to_remove)` 메서드 추가
- frontmatter의 `tags:` 리스트에서 지정된 태그만 제거
- `#` prefix 있는 태그도 처리 (구형 형식 호환)
- frontmatter 없는 파일은 스킵

### 핵심 파일
- `src/__main__.py` - CLI 엔트리포인트
- `src/features/advanced_search.py` - `clean_isolated_tags()` 함수
- `src/core/vault_processor.py` - `remove_tags_from_file()` 헬퍼

### 검증
1. `python -m src clean-tags --dry-run` 실행하여 제거 대상 미리보기
2. 샘플 확인 후 `python -m src clean-tags` 실행
3. `python -m src analyze-gaps` 재실행하여 고립 태그 감소 확인
