# 크루즈 가격 입력 통합 프로세스 - 빠른 참조 가이드

## 🎯 한눈에 보는 전체 프로세스

```
📥 입수 → 📋 표 검증 → 📊 Markdown 제시 → ✅ 승인 → 🔨 SQL 생성 → 💾 실행 → ✔️ 검증 → 📝 지침 업데이트
```

---

## 📚 문서 위치 및 목적

| 문서 | 경로 | 사용 시점 |
|------|------|---------|
| **마스터 프로세스** | CRUISE-PRICE-INTAKE-MASTER-PROCESS.md | 전체 워크플로우 이해 |
| **데이터 검증** | CRUISE-DATA-VALIDATION-CHECKLIST.md | 입수 데이터 검증 시 |
| **SQL 생성** | SQL-GENERATION-WORKFLOW.md | SQL 쿼리 작성 시 |
| **지침 업데이트** | GUIDELINE-UPDATE-PROCESS.md | DB 반영 후 문서 업데이트 |
| **크루즈 지침** | {크루즈명}-PRICING-GUIDELINE.md | 특정 크루즈 규칙 확인 시 |

---

## 🚀 5분 시작 가이드

### 상황: "Grand Fairyness 새 가격표 받았어요"

#### 1️⃣ 크루즈 지침 찾기 (1분)
```
→ GRAND-FAIRYNESS-DATA-INPUT-GUIDELINE.md 열기
→ "데이터 구조" 섹션에서 시즌/객실/가격 규칙 확인
```

#### 2️⃣ 데이터 정제 (3분)
```
→ CRUISE-DATA-VALIDATION-CHECKLIST.md 참조
→ 입수 표를 정규화 (쉼표/점 제거, 날짜 형식 변경)
→ Markdown 테이블로 변환
```

#### 3️⃣ 승인 요청 (1분)
```
→ Markdown 테이블을 사용자에게 보여주기
→ 오류 없으면 "승인됨" 표시
```

#### 4️⃣ SQL 생성 (2분)
```
→ grand-fairyness-rate-card-generated.sql 복사
→ 새 데이터로 DELETE/INSERT 값 변경
→ 새 파일로 저장: grand-fairyness-rate-card-YYYYMMDD.sql
```

#### 5️⃣ Supabase 실행 (1분)
```
→ Supabase SQL Editor에 붙여넣기
→ BEGIN/COMMIT 트랜잭션 실행
→ 영향 행 수 확인
```

#### 6️⃣ 검증 (1분)
```
→ 검증 SELECT 쿼리 실행
→ 기대값과 일치 확인
```

#### 7️⃣ 지침 업데이트 (2분)
```
→ GRAND-FAIRYNESS-DATA-INPUT-GUIDELINE.md 열기
→ "변경 이력" 섹션에 오늘 날짜/내용 추가
→ 가격표 Markdown 테이블 최신 데이터로 갱신
```

**총 소요 시간**: ~11분

---

## 📋 크루즈별 지침 매핑 (빠른 검색)

```
크루즈명 → 지침 파일

✓ Diana
  → DIANA-PRICING-GUIDELINE.md
  → diana-rate-card.sql
  특징: 6객실, 2시즌, 8% 할인

✓ Katherine
  → KATHERINE-PRICING-GUIDELINE.md
  → katherine-rate-card.sql
  특징: 7객실, 1시즌

✓ Halora
  → HALORA-PRICING-GUIDELINE.md
  → halora-rate-card.sql
  특징: 10객실, 2시즌, 연령별 차이

✓ Lyra Granjer
  → LYRA-GRANJER-PRICING-GUIDELINE.md
  → lyra-granjer-rate-card.sql
  특징: 11객실, 3시즌, 유아가 계산식

✓ Grand Fairyness
  → GRAND-FAIRYNESS-DATA-INPUT-GUIDELINE.md
  → grand-fairyness-rate-card-generated.sql
  특징: 10객실, 2시즌, 중반 정책변화

✓ Calista
  → CALISTA-PRICING-GUIDELINE.md
  → calista-rate-card.sql
  특징: 18객실, 3시즌

✓ Serina
  → SERINA-PRICING-GUIDELINE.md
  → serina-rate-card.sql
  특징: 5객실, 1시즌

⚠️ Paradise Legacy
  → 지침 문서 없음 (신규 추가 필요)
```

---

## 🔧 일반적인 시나리오별 대응

### Scenario 1: "기존 크루즈 가격 업데이트"

**입수**: Diana 시즌2 가격 인하 공지

```
1. DIANA-PRICING-GUIDELINE.md 확인
   → S1: 정가 / S2: 8% 할인 정책 확인

2. 입수 표를 정규화
   → 쉼표 제거, 날짜 정렬

3. Markdown 테이블로 제시
   → 사용자 승인

4. diana-rate-card.sql 열기
   → DELETE WHERE cruise_name = '다이아나 크루즈'
   → S2 가격 새로 INSERT
   → 검증 쿼리 추가

5. Supabase 실행
   → BEGIN ~ COMMIT 트랜잭션

6. 결과 검증
   → S2 객실 6개 × 새 가격 확인

7. DIANA-PRICING-GUIDELINE.md 업데이트
   → 변경 이력 추가
   → 가격표 갱신
```

---

### Scenario 2: "새 크루즈 추가"

**입수**: Paradise Legacy 초기 가격표

```
1. 지침 파일 신규 생성: PARADISE-LEGACY-PRICING-GUIDELINE.md
   → Template 참조: GUIDELINE-UPDATE-PROCESS.md

2. 크루즈 기본정보 입력
   → 크루즈명, 형태, 통화, 연도
   → 시즌 정의 (몇 개, 기간)
   → 객실 목록 (몇 개, 이름)

3. 입수 표 정규화 및 검증
   → CRUISE-DATA-VALIDATION-CHECKLIST.md 참조

4. SQL 템플릿 선택 (유사 크루즈)
   → SQL-GENERATION-WORKFLOW.md → "Step 1: 템플릿 선택"

5. SQL 신규 작성
   → paradise-legacy-rate-card.sql 생성

6. 테스트 실행

7. 지침 최종 완성 및 객실별 상세정보 추가
```

---

### Scenario 3: "데이터 오류 발견 후 수정"

**발견**: Grand Fairyness S2 아동가 오류

```
1. 오류 내용 확인
   → "베란다 스위트 아동가가 4,200,000이어야 하는데 3,150,000로 입력됨"

2. SQL 수정
   → grand-fairyness-rate-card-generated.sql 열기
   → WHERE 조건으로 해당 행 찾기
   → UPDATE 구문 작성 또는 DELETE/INSERT로 재입력

3. Supabase 재실행
   → BEGIN ~ ROLLBACK (오류 시) 또는 COMMIT (성공 시)

4. 검증 SELECT 재실행
   → 오류 수정 확인

5. 지침 문서 노트 추가
   → 변경 이력에 "데이터 수정" 항목 추가
   → 수정 사유 기록 (선택)
```

---

## 💡 알아두면 유용한 팁

### Tip 1: 시간 단축 (같은 크루즈 재입력)

```
기존 SQL 파일 복사
→ {크루즈명}-rate-card.sql을 {크루즈명}-rate-card-YYYYMMDD.sql로 복사
→ DELETE WHERE cruise_name = ... (그대로 유지)
→ INSERT 값만 업데이트
→ 트랜잭션 실행
```

**효과**: 5분 → 2분 단축

---

### Tip 2: 대량 데이터 입력 (18개 객실)

```
Calista 같은 대량 객실은:
1. 스프레드시트(엑셀)에 먼저 정리
2. 파이썬 스크립트로 SQL INSERT 문 자동 생성
3. 검증 후 SQL 파일로 저장
```

**추가 문서**: 생성 예정 (Python template)

---

### Tip 3: 예외 상황 처리

| 문제 | 해결책 |
|------|--------|
| "지침이 없는 크루즈" | → GUIDELINE-UPDATE-PROCESS.md Template 사용 신규 생성 |
| "이전 바뀐 값이 뭐였지?" | → 변경 이력 섹션 검토, 또는 Supabase 히스토리 확인 |
| "가격 단위 확인 안 됨" | → 포스팅 원본 재검토 또는 담당자에게 확인요청 |
| "SQL 문법 오류" | → 오류 메시지 복사 → ChatGPT/검색 후 수정 |

---

### Tip 4: 정기적 백업

```
매월 1일:
1. 모든 SQL 파일 복사 → sql/archive/ 폴더로 이동
2. 파일명에 연월 붙이기: 20260301
3. Git에 커밋
```

---

## ✅ 최종 체크리스트 (작업 완료 직전)

```
[ ] Step 1: 지침 파일 확인
    [ ] 올바른 크루즈명
    [ ] 시즌 개수 일치
    [ ] 객실 개수 일치

[ ] Step 2: 표 정제
    [ ] 쉼표/점 제거
    [ ] 특수문자 정규화
    [ ] 날짜 형식 통일

[ ] Step 3: 승인
    [ ] 사용자 확인 완료
    [ ] 변경사항 없음

[ ] Step 4: SQL 생성
    [ ] 파일명 규칙 (YYYYMMDD 포함)
    [ ] DELETE/INSERT 구문 검토
    [ ] 검증 SELECT 쿼리 포함

[ ] Step 5: 실행
    [ ] BEGIN/COMMIT 확인
    [ ] 영향 행 수 기대값 vs 실제값
    [ ] 트랜잭션 완료 확인

[ ] Step 6: 검증
    [ ] SELECT 결과 기대값과 일치
    [ ] 이상 가격 없음
    [ ] 모든 객실/휴일 포함

[ ] Step 7: 지침 업데이트
    [ ] 변경 이력 기록
    [ ] 가격표 최신 데이터 반영
    [ ] 문법/포맷 검토

[ ] Final: 문서화
    [ ] 작업 완료 메모 (변경 사항)
    [ ] 이슈 있었나 기록
    [ ] 다음 예정 사항
```

---

## 📞 도움말

**문제가 생겼을 때**:

1. **데이터 오류**: CRUISE-DATA-VALIDATION-CHECKLIST.md 참조
2. **SQL 오류**: SQL-GENERATION-WORKFLOW.md → 특수 정책 섹션 참조
3. **지침 없는 크루즈**: GUIDELINE-UPDATE-PROCESS.md → Template 참조
4. **특정 크루즈 규칙**: {크루즈명}-PRICING-GUIDELINE.md 확인

---

## 📊 프로세스 효율 지표

| 항목 | 예상 시간 | 최적화 팁 |
|------|---------|---------|
| 지침 찾기 | 1분 | 북마크 추가 |
| 표 정제 | 3~5분 | 엑셀 앞뒤로 사용 |
| SQL 생성 | 2~5분 | 기존 파일 복사 |
| Supabase 실행 | 1~2분 | 트랜잭션 템플릿 활용 |
| 지침 업데이트 | 2~3분 | 계획 미리 작성 |
| **전체** | **9~16분** | 경험 쌓으면 5~10분 |

---

## 🎓 Learning Path (선택사항)

**Week 1**:
1. CRUISE-PRICE-INTAKE-MASTER-PROCESS.md 읽기
2. 기존 지침 2개 검토 (Diana, Grand Fairyness)
3. SQL-GENERATION-WORKFLOW.md 읽기

**Week 2**:
4. 간단한 크루즈 (Katherine) 가격표 입력 실습
5. CRUISE-DATA-VALIDATION-CHECKLIST.md 실제 적용

**Week 3**:
6. 복잡한 크루즈 (Lyra Granjer) 실습
7. 새 크루즈 추가 (Paradise Legacy) 시뮬레이션

---

**마지막 업데이트**: 2026년 2월 21일

**다음 개선 예정**:
- [ ] Python 스크립트 (대량 SQL 생성 자동화)
- [ ] Batch 처리 가이드 (여러 크루즈 동시 입력)
- [ ] API 연동 (카페 포스팅 자동 수집 - TBD)
