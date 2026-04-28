# Capella Cruise (카펠라 크루즈) - Data Input Guideline
## 2박 3일 (2N3D) 객실요금 입력 지침

---

## 1. 프로젝트 개요

**크루즈명**: 카펠라 크루즈 (Capella Cruise)  
**상품타입**: 2박 3일 (2N3D)  
**통화**: VND 베트남동  
**연도**: 2026년  
**결제 방법**: 신용카드 (크레딧카드만 가능)  
**시즌 구분**: 3개 (계절별 요금 차등)

---

## 2. 시즌 정의

### 2.1 시즌 1: 저수기 (2026/01/01 - 04/30)
- **특징**: 1월 설날 제외, 상대적으로 낮은 수요
- **가격대**: 가장 저렴
- **예**: 오아시스 스위트 = 10,800,000동

### 2.2 시즌 2: 성수기 (2026/05/01 - 09/30)
- **특징**: 여름 휴가철, 중급 수요
- **가격대**: 중간 가격
- **예**: 오아시스 스위트 = 10,300,000동 (저수기 대비 약 4.6% 할인)

### 2.3 시즌 3: 최성수기 (2026/10/01 - 12/31)
- **특징**: 10월~12월 연휴(TET 제외), 가장 높은 수요
- **가격대**: 가장 높음
- **예**: 오아시스 스위트 = 11,300,000동 (저수기 대비 약 4.6% 인상)

---

## 3. 객실 타입 및 요금 정보

### 3.1 객실 분류

#### 일반 스위트 (4종류 - 엑스트라베드 가능)
| 객실명 | 시즌1<br/>(저수기) | 시즌2<br/>(성수기) | 시즌3<br/>(최성수기) | 아동 | 엑스트라<br/>베드 |
|--------|-------|-------|-------|------|---------|
| 오아시스 스위트 | 10,800,000 | 10,300,000 | 11,300,000 | 가격대 낮음 | ✓ |
| 하모니 스위트 | 11,600,000 | 11,000,000 | 12,200,000 | 가격대 낮음 | ✓ |
| 스카이 스위트 | 12,600,000 | 12,000,000 | 13,200,000 | 가격대 낮음 | ✓ |
| 스카이 테라스 스위트 | 15,400,000 | 14,600,000 | 16,000,000 | 가격대 낮음 | ✓ |

#### 패밀리 스위트 (3종류 - 정원제, 아동 요금 없음)
| 객실명 | 시즌1<br/>(저수기) | 시즌2<br/>(성수기) | 시즌3<br/>(최성수기) | 특징 |
|--------|-------|-------|-------|------|
| 하모니 패밀리 (4인 기준) | 10,200,000 | 9,700,000 | 10,600,000 | 정원제, 엑스트라베드 불가 |
| 하모니 패밀리 (5인 기준) | 9,600,000 | 9,300,000 | 10,100,000 | 정원제, 엑스트라베드 불가 |
| 스카이 패밀리 (4인 기준) | 10,800,000 | 10,400,000 | 11,400,000 | 정원제, 엑스트라베드 불가 |

#### 럭셔리 스위트 (2종류 - 엑스트라베드 불가)
| 객실명 | 시즌1<br/>(저수기) | 시즌2<br/>(성수기) | 시즌3<br/>(최성수기) | 특징 |
|--------|-------|-------|-------|------|
| 라 스위트 드 카펠라 | 22,300,000 | 21,600,000 | 23,300,000 | 최고급, 아동 수용 가능 |
| 오너스 스위트 | 33,300,000 | 30,400,000 | 34,800,000 | 프리미엄, 아동 수용 가능 |

---

## 4. 데이터 구조

### 4.1 cruise_rate_card 테이블

**목적**: 기본 객실 요금 관리 (시즌별 요금 차등)

| 컬럼 | 값 | 비고 |
|------|-----|------|
| cruise_name | 카펠라 크루즈 | 고정값 |
| schedule_type | 2N3D | 2박 3일 구분자 |
| room_type | 오아시스 스위트 | 객실명 |
| room_type_en | Oasis Suite | 영문 표현 |
| price_adult | 10,800,000 또는 10,300,000 또는 11,300,000 | 시즌별 상이 |
| price_child | 5,500,000 또는 5,200,000 또는 5,700,000 | 시즌별 상이 (패밀리 스위트는 NULL) |
| price_infant | NULL | 유아 정책별 계산 |
| price_extra_bed | 8,200,000 또는 7,600,000 또는 8,300,000 | 시즌별 상이 (럭셔리는 NULL) |
| price_child_extra_bed | 5,500,000 또는 5,200,000 또는 5,700,000 | 시즌별 상이 |
| price_single | 15,900,000 또는 15,500,000 또는 17,000,000 | 1인 싱글차지 (럭셔리는 다름) |
| extra_bed_available | true/false | 패밀리/럭셔리는 false |
| valid_year | 2026 | 유효 연도 |
| valid_from | 2026-01-01 또는 2026-05-01 또는 2026-10-01 | 시즌 시작일 |
| valid_to | 2026-04-30 또는 2026-09-30 또는 2026-12-31 | 시즌 종료일 |
| currency | VND | 통화 |
| season_name | 시즌1 (01/01-04/30) 또는 시즌2 (05/01-09/30) 또는 시즌3 (10/01-12/31) | **시즌 표시** |
| is_active | true | 활성화 상태 |

**총 행 수**: 30행 (10 객실 × 3 시즌)

### 4.2 cruise_holiday_surcharge 테이블

**목적**: 휴일 추가요금 관리

| 컬럼 | 값 | 비고 |
|------|-----|------|
| cruise_name | 카펠라 크루즈 | 고정값 |
| schedule_type | 2N3D | 2박 3일 구분자 |
| holiday_date | (미정) | 휴일 시작일 |
| holiday_date_end | (미정) | 다중일 휴일의 종료일 |
| holiday_name | (미정) | 휴일명 (TET, 크리스마스 등) |
| surcharge_per_person | (미정) | 성인 추가요금 |
| surcharge_child | (미정) | 아동 추가요금 |
| surcharge_type | per_person | 개인당 합산 방식 |
| valid_year | 2026 | 유효 연도 |
| currency | VND | 통화 |
| is_confirmed | true/false | 확정 여부 |

**총 행 수**: (미정 - TET, 크리스마스 추가 공지 필요)

---

## 5. 주요 특징 및 정책

### 5.1 시즌별 가격 변동

**일반 스위트 (오아시스 스위트)**:
- 시즌1 (저수기): 10,800,000동
- 시즌2 (성수기): 10,300,000동 (-4.6%, 5월-9월 할인)
- 시즌3 (최성수기): 11,300,000동 (+4.6%, 10월-12월 인상)

**럭셔리 스위트 (오너스)**:
- 시즌1 (저수기): 33,300,000동
- 시즌2 (성수기): 30,400,000동 (-8.7%, 최대 할인)
- 시즌3 (최성수기): 34,800,000동 (+4.5%)

### 5.2 패밀리 스위트 특수 정책

**정원제 운영**:
- 4인 또는 5인 기준으로 책정
- 추가 침대 없음 (정원 초과 불가)
- 아동 요금 없음 (성인 기준 요금만 존재)
- extra_bed_available = false

**예시**:
- 4인 패밀리: 10,200,000동 (1박 전체 = 4인 기준 1인당 약 2,550,000동)
- 5인 패밀리: 9,600,000동 (1박 전체 = 5인 기준 1인당 약 1,920,000동)

### 5.3 럭셔리 스위트 특수 정책

**라 스위트 드 카펠라 & 오너스 스위트**:
- 엑스트라베드 불가 (정원제)
- 아동 수용 가능 (일반 요금 적용)
- 더 높은 싱글 차지

**예시**:
- 오너스: 성인 1인당 33,300,000동 (시즌1)
- 싱글 차지: 49,400,000동 (1인실)

### 5.4 유아 요금 정책

**4세 이하 유아**:
- **1인 무료**: 객실당 첫 번째 유아는 무료
- **2인 이상**: 두 번째 유아부터 **성인 요금의 30% 적용**

**예시**:
- 성인 2명 + 유아 1명: 성인 요금만 청구
- 성인 2명 + 유아 2명: 성인 요금 + (유아 1인당 성인 요금 × 30%)

### 5.5 아동 요금 정책

**일반 스위트 & 럭셔리**:
- 아동은 성인 요금의 약 50% 수준
- 시즌별로 상이함

**패밀리 스위트**:
- 아동 별도 요금 없음 (정원제에 포함)

---

## 6. 데이터베이스 매핑

### 6.1 room_type 명명 규칙

```
"{객실명}"
```

**예시**:
- `오아시스 스위트`
- `하모니 스위트`
- `라 스위트 드 카펠라`
- `하모니 패밀리 스위트 (4인)`

**중요**: 시즌은 season_name으로 구분되므로 room_type에 시즌 정보 미포함

---

## 7. 검증 쿼리

### 7.1 시즌1 (저수기: 01/01-04/30) 요금 확인

```sql
SELECT 
  season_name as "시즌",
  room_type as "객실명",
  price_adult as "성인",
  price_child as "아동",
  price_infant as "유아",
  price_extra_bed as "엑스트라베드",
  price_single as "싱글차지",
  CASE WHEN extra_bed_available THEN 'O' ELSE 'X' END as "추가가능"
FROM cruise_rate_card
WHERE cruise_name = '카펠라 크루즈'
  AND schedule_type = '2N3D'
  AND season_name = '시즌1 (01/01-04/30)'
ORDER BY price_adult DESC;
```

**예상 결과**: 10행 (10개 객실)

### 7.2 시즌2 (성수기: 05/01-09/30) 요금 확인

```sql
SELECT 
  season_name as "시즌",
  room_type as "객실명",
  price_adult as "성인",
  price_child as "아동",
  price_infant as "유아",
  price_extra_bed as "엑스트라베드",
  price_single as "싱글차지",
  CASE WHEN extra_bed_available THEN 'O' ELSE 'X' END as "추가가능"
FROM cruise_rate_card
WHERE cruise_name = '카펠라 크루즈'
  AND schedule_type = '2N3D'
  AND season_name = '시즌2 (05/01-09/30)'
ORDER BY price_adult DESC;
```

**예상 결과**: 10행 (10개 객실)

### 7.3 시즌3 (최성수기: 10/01-12/31) 요금 확인

```sql
SELECT 
  season_name as "시즌",
  room_type as "객실명",
  price_adult as "성인",
  price_child as "아동",
  price_infant as "유아",
  price_extra_bed as "엑스트라베드",
  price_single as "싱글차지",
  CASE WHEN extra_bed_available THEN 'O' ELSE 'X' END as "추가가능"
FROM cruise_rate_card
WHERE cruise_name = '카펠라 크루즈'
  AND schedule_type = '2N3D'
  AND season_name = '시즌3 (10/01-12/31)'
ORDER BY price_adult DESC;
```

**예상 결과**: 10행 (10개 객실)

### 7.4 데이터 개수 확인

```sql
SELECT 
  (SELECT COUNT(*) FROM cruise_rate_card 
   WHERE cruise_name = '카펠라 크루즈' AND schedule_type = '2N3D') as "객실가격행 (30행 예상)",
  (SELECT COUNT(*) FROM cruise_holiday_surcharge 
   WHERE cruise_name = '카펠라 크루즈' AND schedule_type = '2N3D') as "휴일추가행 (미정)";
```

**예상 결과**: 객실 30행, 휴일 추가행은 미정

### 7.5 시즌별 가격 비교

```sql
SELECT 
  s1.room_type as "객실명",
  s1.price_adult as "시즌1 (저수기)",
  s2.price_adult as "시즌2 (성수기)",
  s3.price_adult as "시즌3 (최성수기)",
  (s2.price_adult - s1.price_adult) as "변동1→2",
  (s3.price_adult - s2.price_adult) as "변동2→3",
  ROUND(((s3.price_adult - s1.price_adult)::float / s1.price_adult * 100)::numeric, 1) as "총변동율_%"
FROM (
  SELECT room_type, price_adult FROM cruise_rate_card 
  WHERE cruise_name = '카펠라 크루즈' AND schedule_type = '2N3D' AND season_name = '시즌1 (01/01-04/30)'
) s1
FULL JOIN (
  SELECT room_type, price_adult FROM cruise_rate_card 
  WHERE cruise_name = '카펠라 크루즈' AND schedule_type = '2N3D' AND season_name = '시즌2 (05/01-09/30)'
) s2 ON s1.room_type = s2.room_type
FULL JOIN (
  SELECT room_type, price_adult FROM cruise_rate_card 
  WHERE cruise_name = '카펠라 크루즈' AND schedule_type = '2N3D' AND season_name = '시즌3 (10/01-12/31)'
) s3 ON s1.room_type = s3.room_type
ORDER BY s3.price_adult DESC;
```

**예상 결과**: 10행 (객실별 시즌 가격 비교)

### 7.6 패밀리 스위트 검증

```sql
SELECT 
  room_type as "객실명",
  price_adult as "기준가격",
  price_child as "아동요금",
  extra_bed_available as "엑스트라베드",
  CASE WHEN price_child IS NULL AND extra_bed_available = false THEN '정원제' ELSE '표준' END as "타입"
FROM cruise_rate_card
WHERE cruise_name = '카펠라 크루즈'
  AND schedule_type = '2N3D'
  AND room_type LIKE '%패밀리%'
ORDER BY season_name;
```

**예상 결과**: 9행 (3개 패밀리 객실 × 3 시즌)

### 7.7 엑스트라베드 가능 객실 확인

```sql
SELECT 
  season_name as "시즌",
  COUNT(*) as "엑스트라베드_가능_객실"
FROM cruise_rate_card
WHERE cruise_name = '카펠라 크루즈'
  AND schedule_type = '2N3D'
  AND extra_bed_available = true
GROUP BY season_name
ORDER BY season_name;
```

**예상 결과**: 3행 (시즌별 4개 객실)

---

## 8. 배포 절차

1. **SQL 파일 실행**: `capella-rate-card-2n3d.sql`
2. **검증 쿼리 실행**: Section 7의 쿼리들 순서대로 실행
3. **데이터 확인**:
   - ✓ 객실 가격행 30행 확인 (10 객실 × 3 시즌)
   - ✓ 시즌명이 정확히 "시즌1 (01/01-04/30)" 등으로 표시되었는지 확인
   - ✓ 패밀리 스위트 아동 요금 NULL 확인
   - ✓ 럭셔리 스위트 엑스트라베드 FALSE 확인
   - ✓ 시즌별 가격 변동 확인 (저수기 < 성수기 또는 최성수기)
4. **휴일 추가요금**: TET, 크리스마스 등 특수일 공지 후 별도 처리
5. **완료**: 배포 로그 기록

---

## 9. 향후 조정사항

### 추가 필요 정보
- [ ] TET 기간 (구정 연휴) 추가요금 확인
- [ ] 크리스마스 & 신년 추가요금 확인
- [ ] 추가 휴일 또는 특수일 정의

### 선택 사항
- [ ] 그룹 할인 정책 (대인수 예약)
- [ ] 얼리버드 할인
- [ ] 라스트미닛 할인

---

**문서 버전**: 1.0  
**작성일**: 2026년 2월 21일  
**상태**: ✅ 배포 준비 완료
