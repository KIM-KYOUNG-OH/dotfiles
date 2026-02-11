# Plan: vault-intelligence pipx 설치 가능하게 만들기

## Context

현재 `python -m src search --query "TDD"` 형태로 프로젝트 디렉토리에서만 실행 가능.
pipx로 설치하여 `vault-intel search --query "TDD"` 형태로 어디서든 실행 가능하게 변경.

**핵심 발견:** `project_root`에 의존하는 코드는 `src/__main__.py` 한 곳뿐.
핵심 모듈(engine, cache, search 등)은 모두 `cache_dir`을 외부에서 주입받는 구조라 변경 범위가 작음.

## 변경 방향

- 기존 프로젝트 루트(`~/git/vault-intelligence/`)를 데이터 디렉토리 기본값으로 유지
- `--data-dir` 옵션으로 오버라이드 가능
- 기존 캐시, 설정, 모델을 그대로 활용

## 작업 목록

### Step 1: `pyproject.toml` 생성
- **파일:** `/Users/msbaek/git/vault-intelligence/pyproject.toml` (신규)
- entry point: `vault-intel = "src.__main__:main"`
- `requirements.txt` 내용을 `dependencies`로 이동
- `src` 패키지 포함 설정

### Step 2: `src/__main__.py`의 `project_root` 로직 수정
- **파일:** `/Users/msbaek/git/vault-intelligence/src/__main__.py`
- 현재: `project_root = Path(__file__).parent.parent` (소스코드 위치 기반)
- 변경: 데이터 디렉토리 결정 로직 추가
  ```
  우선순위:
  1. CLI 인자 --data-dir
  2. 환경변수 VAULT_INTELLIGENCE_HOME
  3. 기본값: ~/git/vault-intelligence
  ```
- `project_root` 변수를 `data_dir`로 의미 변경 (또는 `get_data_dir()` 함수)
- config, cache, models 경로가 `data_dir` 기준으로 결정되도록 수정

### Step 3: `config/settings.yaml`을 패키지 데이터로 포함
- `pyproject.toml`에서 `package-data`로 `config/settings.yaml` 포함
- 사용자 데이터 디렉토리에 설정파일이 없으면 기본 설정 사용

### Step 4: pipx 설치 및 검증
- `brew install pipx` (pipx가 아직 미설치)
- `pipx install -e ~/git/vault-intelligence` (editable 모드)
- 다른 디렉토리에서 `vault-intel search --query "TDD"` 실행하여 검증
- `vault-intel info` 로 경로 확인

## 검증 방법

```bash
# 1. pipx 설치
brew install pipx && pipx ensurepath

# 2. vault-intelligence 설치
pipx install -e ~/git/vault-intelligence

# 3. 다른 디렉토리에서 실행 테스트
cd /tmp
vault-intel info
vault-intel search --query "TDD" --top-k 3

# 4. 기존 방식도 여전히 동작 확인
cd ~/git/vault-intelligence
python -m src search --query "TDD" --top-k 3
```

## 주요 수정 파일
- `pyproject.toml` (신규)
- `src/__main__.py` (project_root 로직 수정)
