# 크루즈 가격 데이터 입력 통합 프로세스 (Master)

## 📋 개요

이 문서는 **크루즈 가격 정보 업데이트**를 받았을 때 데이터베이스에 반영하기 위한 **표준화된 통합 프로세스**입니다.

---

## 🎯 프로세스 흐름도

```
① 가격표 원본 입수
   ↓
② 크루즈명 파악 → 해당 크루즈 지침 검색
   ↓
③ 지침 규칙에 따라 표 형식 검증 & 변환
   ↓
④ 변환된 표를 Markdown 테이블로 표시 (확인용)
   ↓
⑤ 사용자 승인 후 SQL 쿼리 생성
   ↓
⑥ SQL 미리보기 → 트랜잭션 UPDATE/INSERT 실행
   ↓
⑦ 검증 쿼리로 DB 업데이트 확인
   ↓
⑧ 지침 문서 최종 업데이트 (변경 이력 포함)
```

---

## 📂 크루즈별 지침 파일 매핑

| 크루즈명 | 지침 파일 | SQL 파일 | 특징 |
|--------|---------|---------|------|
| Diana | `DIANA-PRICING-GUIDELINE.md` | `diana-rate-card.sql` | 6 객실, 2 시즌, 8% 계절할인 |
| Lyra Granjer | `LYRA-GRANJER-PRICING-GUIDELINE.md` | `lyra-granjer-rate-card.sql` | 11 객실, 3 시즌, 유아요금 30% |
| Grand Fairyness | `GRAND-FAIRYNESS-DATA-INPUT-GUIDELINE.md` | `grand-fairyness-rate-card-generated.sql` | 10 객실, 2 시즌, 중반 인하공지 |
| Katherine | `KATHERINE-PRICING-GUIDELINE.md` | `katherine-rate-card.sql` | 7 객실, 1 시즌 |
| Halora | `HALORA-PRICING-GUIDELINE.md` | `halora-rate-card.sql` | 10 객실, 2 시즌, 연령별 아동차 |
| Calista | `CALISTA-PRICING-GUIDELINE.md` | `calista-rate-card.sql` | 18 객실, 3 시즌 |
| Serina | `SERINA-PRICING-GUIDELINE.md` | `serina-rate-card.sql` | 5 객실, 1 시즌 |
| Paradise Legacy | `PARADISE-LEGACY-PRICING-GUIDELINE.md` | (TBD) | (TBD) |

---

## 🔄 Step-by-Step 프로세스

### Step 1: 원본 데이터 준비

**입력 형식**:
```
원본: 카페 포스팅 (스테이하롱 커뮤니티) 또는 크루즈사 공식 가격표
- 객실별 가격 표 (1개 이상)
- 휴일/성수기 추가요금 정보
- 유효 기간 (from ~ to)
```

---

### Step 2: 크루즈명 파악 & 지침 검색

**입력된 크루즈명이 명확하면**:

| 입력 | 검색 지침 | 비고 |
|------|---------|------|
| "다이아나 크루즈 2026" | DIANA-PRICING-GUIDELINE.md | 위의 테이블 확인 |
| "Lyra Granjer Cruise" | LYRA-GRANJER-PRICING-GUIDELINE.md | 크루즈명 정규화 필요 |
| "그랜드 파이어니스" | GRAND-FAIRYNESS-DATA-INPUT-GUIDELINE.md | 정확한 매핑 확인 |

**팁**:
- 지침 파일이 없으면 → 새 크루즈 추가 절차 진행 (Step 9 참조)
- 부분 일치만 가능하면 → 담당자에게 확인

---

### Step 3: 지침 규칙에 따라 원본 표 검증

**각 크루즈 지침에서 확인할 항목**:

1. **시즌 분류**
   - 몇 개의 시즌인가? (지침에 명시)
   - 각 시즌의 유효 기간은?
   - 시즌 간 정책 변화가 있나?

2. **객실 목록**
   - 몇 개의 객실인가?
   - 각 객실의 정확한 이름
   - 객실별 특수성 (불가 옵션, 패키지 등)

3. **가격 컬럼 규칙**
   - price_adult: 항상 입력됨
   - price_child: 빈칸/불가/"동일" 해석 규칙 확인
   - price_infant, price_extra_bed 등 정책 확인

4. **특수 케이스**
   - 아동 불가 객실: price_child = NULL
   - 패키지 객실: price_child = price_adult
   - 계절할인: 계산식 확인

---

### Step 4: 변환된 표 제시 (사용자 승인용)

**Markdown 테이블로 정리된 형태로 표시**:

예시:
```markdown
### 📊 시즌1: 2026/02/01 - 02/28 (정가)

| 객실명 | 성인 | 아동 | 엑스트라 | 싱글차지 |
|--------|-----|-----|--------|--------|
| 오션스위트 | 5,250,000 | 3,200,000 | 4,800,000 | 8,600,000 |
| 베란다 스위트 | 6,300,000 | 3,200,000 | 5,600,000 | 10,200,000 |
```

**사용자 액션**:
- ✅ 표 내용 확인 및 승인
- ❌ 오류 발견 시 → 정정 후 재제시

---

### Step 5: SQL 쿼리 생성

**생성 방식**:

1. 기존 SQL 템플릿 검색 (예: `diana-rate-card.sql`)
2. 템플릿 구조 따르기:
   ```sql
   -- 1. DELETE 기존 데이터
   DELETE FROM cruise_rate_card WHERE cruise_name = '크루즈명';
   DELETE FROM cruise_holiday_surcharge WHERE cruise_name = '크루즈명';
   
   -- 2. INSERT 새 데이터 (시즌별 섹션)
   INSERT INTO cruise_rate_card (...) VALUES (시즌1 데이터);
   INSERT INTO cruise_rate_card (...) VALUES (시즌2 데이터);
   
   -- 3. INSERT 휴일 추가요금
   INSERT INTO cruise_holiday_surcharge (...) VALUES (...);
   
   -- 4. VERIFY 검증 SELECT
   SELECT ... FROM cruise_rate_card WHERE cruise_name = '크루즈명';
   ```

3. 파일명: `{크루즈-영문-소문자}-rate-card-YYYYMMDD.sql` (날짜 포함)

---

### Step 6: SQL 미리보기 & 트랜잭션 실행

**Supabase 실행 절차**:

1. **Preview**: DELETE/INSERT 전 영향 범위 확인
   ```sql
   -- 삭제될 기존 데이터 확인
   SELECT COUNT(*) FROM cruise_rate_card WHERE cruise_name = '크루즈명';
   ```

2. **Transaction 블록**: 안전한 롤백 가능하게 실행
   ```sql
   BEGIN;
   -- DELETE & INSERT 구문 실행
   COMMIT;  -- 또는 문제 발생 시 ROLLBACK;
   ```

3. **Result**: 삽입 행 수 확인

---

### Step 7: 검증 & 확인

**검증 쿼리 실행**:

```sql
-- 시즌별 객실 개수 확인
SELECT schedule_type, COUNT(*) FROM cruise_rate_card 
WHERE cruise_name = '크루즈명'
GROUP BY schedule_type;

-- 휴일 추가요금 확인
SELECT COUNT(*) FROM cruise_holiday_surcharge
WHERE cruise_name = '크루즈명';

-- 가격 범위 확인 (이상 데이터 감지)
SELECT MIN(price_adult), MAX(price_adult) FROM cruise_rate_card
WHERE cruise_name = '크루즈명';
```

---

### Step 8: 지침 문서 업데이트

**변경 이력 추가 (지침 파일 상단에)**:

```markdown
## 📝 변경 이력

| 날짜 | 시즌 | 변경 내용 | 상태 |
|------|------|---------|------|
| 2026-02-21 | S1 (2026/02) | 시즌1 가격 책정, 휴일 추가 | ✅ 완료 |
| 2026-03-01 | S2 (2026/03-12) | 시즌2 인하 공지 | ✅ 완료 |
```

**변경 항목 예시**:
- 새로운 객실 추가/제거
- 가격 변동 사항
- 시즌 정책 변경
- 휴일/성수기 추가

---

### Step 9: 새 크루즈 신규 지침 생성 (Template)

**새 크루즈가 추가될 때**:

1. 지침 파일 생성: `{크루즈명}-PRICING-GUIDELINE.md`
2. 다음 Template 사용:

```markdown
# {크루즈명} 가격 데이터 입력 지침

## 📋 개요

**크루즈명**: {크루즈명}
**여행 형태**: {예: 1박2일, 2박3일}
**통화**: VND (베트남동)
**유효년도**: 2026년

## 🎯 데이터 구조

### 시즌 분류
- **시즌 1**: {기간} ({설명})
- **시즌 2**: {기간} ({설명})

### 객실 목록 ({개수}개)
| 번호 | 객실명 | 특징 |
|------|--------|------|
| 1 | {객실1} | {특징} |

### 가격 컬럼 규칙
| 컬럼 | 규칙 | 예시 |
|------|------|------|

## ✅ 입력 체크리스트
- [ ] 시즌별 가격표 추출
- [ ] 휴일 추가요금 추출
- [ ] 특수 케이스 식별
- [ ] 표로 변환 및 검증
- [ ] SQL 생성
- [ ] 검증 완료
```

---

## 📋 통합 체크리스트

```
🎯 가격표 입수 시 따를 체크리스트

[ ] Step 1: 원본 데이터 형식 확인
    [ ] 객실별 가격 표 있음
    [ ] 휴일/성수기 정보 있음
    [ ] 유효 기간 명시됨

[ ] Step 2: 크루즈 지침 검색
    [ ] 크루즈명 파악
    [ ] 해당 지침 파일 위치 확인
    [ ] 지침 규칙 리뷰

[ ] Step 3: 표 검증
    [ ] 시즌 개수 확인
    [ ] 객실 개수 확인
    [ ] 특수 케이스 식별

[ ] Step 4: Markdown 표 제시
    [ ] 표 포맷 정렬
    [ ] 사용자 승인 완료

[ ] Step 5: SQL 생성
    [ ] 템플릿 선택
    [ ] DELETE/INSERT 구문 작성
    [ ] 검증 SELECT 쿼리 포함

[ ] Step 6: 미리보기 & 실행
    [ ] Preview 쿼리 실행
    [ ] BEGIN/COMMIT 트랜잭션 확인
    [ ] 행 수 확인

[ ] Step 7: 최종 검증
    [ ] 시즌별 객실 개수 일치
    [ ] 휴일 추가요금 개수 일치
    [ ] 가격 범위 이상 없음

[ ] Step 8: 지침 업데이트
    [ ] 변경 이력 기록
    [ ] 주요 변경사항 요약
    [ ] 예시 데이터 업데이트
```

---

## 🚀 빠른 시작 (Quick Start)

### 예제 1: Grand Fairyness 가격표 업데이트

**입수**: 카페 포스팅 새 가격표
```
1. 지침 확인: GRAND-FAIRYNESS-DATA-INPUT-GUIDELINE.md
2. 시즌 확인: 2026/02/01-02/28 (S1) + 2026/03/01-12/31 (S2)
3. 표 변환: Markdown 테이블로 정리
4. SQL 생성: grand-fairyness-rate-card-generated.sql 참고
5. 실행: Supabase SQL Editor
6. 지침 업데이트: 변경 이력 기록
```

### 예제 2: 새 크루즈 "Paradise Legacy" 추가

**입수**: 크루즈사 공식 가격표
```
1. 지침 파일 생성: PARADISE-LEGACY-PRICING-GUIDELINE.md
2. 시즌/객실/가격 규칙 정의
3. SQL 템플릿 작성: paradise-legacy-rate-card.sql
4. 테스트 데이터 입력 및 검증
5. 최종 확인 후 프로덕션 반영
```

---

## 📞 문의 및 예외 처리

| 상황 | 조치 |
|------|------|
| 지침 파일 없음 | → Step 9: 새 크루즈 지침 생성 |
| 표 형식 불명확 | → 원본 데이터 확인/재요청 |
| SQL 실행 오류 | → 트랜잭션 ROLLBACK 후 재검토 |
| 검증 불일치 | → 데이터 재확인/수정 후 재실행 |

---

**마지막 업데이트**: 2026년 2월 21일
