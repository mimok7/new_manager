# Lyra Granjer Cruise (라이라 그랜져 크루즈) - Data Input Guideline
## 2박 3일 (2N3D) 객실요금 입력 지침

---

## 1. 프로젝트 개요

**크루즈명**: 라이라 그랜져 크루즈 (Lyra Granjer Cruise)  
**상품타입**: 2박 3일 (2N3D)  
**통화**: VND 베트남동  
**연도**: 2026년  
**결제 방법**: 신용카드 (크레딧카드만 가능)  
**시즌 구분**: 3개 (저수기, 성수기, 최성수기)

---

## 2. 시즌 정의

### 2.1 시즌 1: 저수기 (2026/01/01 - 04/30)
- **기간**: 1월 1일 ~ 4월 30일
- **상세**: 설날 제외, 상대적으로 낮은 수요

### 2.2 시즌 2: 성수기 (2026/05/01 - 09/30)
- **기간**: 5월 1일 ~ 9월 30일
- **상세**: 여름 휴가철, 중급 수요

### 2.3 시즌 3: 최성수기 (2026/10/01 - 12/31)
- **기간**: 10월 1일 ~ 12월 31일
- **상세**: 연휴 시즌, 가장 높은 수요

---

## 3. 객실 타입 및 요금 정보

### 3.1 일반 스위트 (4종류 - 엑스트라베드 가능)

| 객실명 | 시즌1<br/>(저수기) | 시즌2<br/>(성수기) | 시즌3<br/>(최성수기) | 아동 | 유아 |
|--------|-------|-------|-------|------|------|
| 오아시스 스위트 (1층) | 12,200,000 | 11,700,000 | 12,900,000 | 제공 | 제공 |
| 하모니 스위트 (2층) | 13,200,000 | 12,600,000 | 13,800,000 | 제공 | 제공 |
| 스카이 스위트 (3층) | 14,400,000 | 13,800,000 | 15,200,000 | 제공 | 제공 |
| 스카이 테라스 스위트 (3층) | 20,000,000 | 19,100,000 | 21,000,000 | 제공 | 제공 |

### 3.2 패밀리 스위트 (5종류 - 정원제)

| 객실명 | 시즌1<br/>(저수기) | 시즌2<br/>(성수기) | 시즌3<br/>(최성수기) | 특징 |
|--------|-------|-------|-------|------|
| 오아시스 패밀리 (1층/4인) | 11,100,000 | 10,600,000 | 11,600,000 | 정원제 |
| 하모니 패밀리 (2층/4-5인) | 11,900,000 | 11,300,000 | 12,600,000 | 정원제 |
| 스카이 패밀리 (3층/4인) | 13,000,000 | 12,400,000 | 13,800,000 | 정원제 |
| 스카이 테라스 패밀리 (3층/4인) | 14,300,000 | 13,700,000 | 15,100,000 | 정원제 |
| 듀플렉스 패밀리 (3-4층/4인) | 15,600,000 | 15,000,000 | 16,500,000 | 정원제 |

### 3.3 럭셔리 스위트 (2종류)

| 객실명 | 시즌1<br/>(저수기) | 시즌2<br/>(성수기) | 시즌3<br/>(최성수기) | 특징 |
|--------|-------|-------|-------|------|
| 라 스위트 드 LYRA (2층) | 25,700,000 | 24,600,000 | 27,000,000 | 럭셔리 |
| 오너스 스위트 | 49,600,000 | 47,200,000 | 52,000,000 | 프리미엄 |

---

## 4. 데이터 구조

### 4.1 cruise_rate_card 테이블

**목적**: 기본 객실 요금 관리 (시즌별 요금)

| 컬럼 | 설명 |
|------|------|
| cruise_name | 라이라 그랜져 크루즈 |
| schedule_type | 2N3D (2박 3일) |
| room_type | 객실명 (예: 오아시스 스위트 1층) |
| room_type_en | 영문 객실명 |
| price_adult | 성인 요금 (시즌별 상이) |
| price_child | 아동 요금 (1박 2일 × 2) |
| price_infant | 유아 요금 (성인 × 30%) |
| price_extra_bed | 엑스트라베드 요금 |
| price_child_extra_bed | 아동 엑스트라베드 요금 |
| price_single | 싱글차지 요금 |
| extra_bed_available | 엑스트라베드 가능 여부 (true/false) |
| valid_year | 2026 |
| valid_from | 시즌 시작일 |
| valid_to | 시즌 종료일 |
| currency | VND |
| season_name | 시즌명 (예: 시즌1 (01/01-04/30)) |
| is_active | true |

**총 행 수**: 33행 (11 객실 × 3 시즌)

---

## 5. 객실 정책

### 5.1 일반 스위트
- 엑스트라베드 추가 가능
- 아동, 유아, 싱글차지 기능

### 5.2 패밀리 스위트
- 정원제 (4인 또는 4-5인)
- 엑스트라베드 불가
- 아동 요금 없음 (정원 기준 요금)
- 싱글차지 불가

### 5.3 럭셔리 스위트
- 엑스트라베드 불가
- 높은 싱글차지
- 아동, 유아 옵션 제공

---

## 6. 검증 쿼리

### 6.1 시즌1 요금 확인

```sql
SELECT 
  room_type as "객실명",
  price_adult as "성인",
  price_child as "아동",
  price_infant as "유아",
  price_extra_bed as "엑스트라베드",
  price_single as "싱글차지",
  CASE WHEN extra_bed_available THEN 'O' ELSE 'X' END as "추가가능"
FROM cruise_rate_card
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND schedule_type = '2N3D'
  AND season_name = '시즌1 (01/01-04/30)'
ORDER BY price_adult DESC;
```

**예상 결과**: 11행

### 6.2 시즌2 요금 확인

```sql
SELECT 
  room_type as "객실명",
  price_adult as "성인",
  price_child as "아동",
  price_infant as "유아",
  price_extra_bed as "엑스트라베드",
  price_single as "싱글차지",
  CASE WHEN extra_bed_available THEN 'O' ELSE 'X' END as "추가가능"
FROM cruise_rate_card
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND schedule_type = '2N3D'
  AND season_name = '시즌2 (05/01-09/30)'
ORDER BY price_adult DESC;
```

**예상 결과**: 11행

### 6.3 시즌3 요금 확인

```sql
SELECT 
  room_type as "객실명",
  price_adult as "성인",
  price_child as "아동",
  price_infant as "유아",
  price_extra_bed as "엑스트라베드",
  price_single as "싱글차지",
  CASE WHEN extra_bed_available THEN 'O' ELSE 'X' END as "추가가능"
FROM cruise_rate_card
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND schedule_type = '2N3D'
  AND season_name = '시즌3 (10/01-12/31)'
ORDER BY price_adult DESC;
```

**예상 결과**: 11행

### 6.4 데이터 개수 확인

```sql
SELECT 
  (SELECT COUNT(*) FROM cruise_rate_card 
   WHERE cruise_name = '라이라 그랜져 크루즈' AND schedule_type = '2N3D') as "객실가격행 (33행 예상)",
  (SELECT COUNT(*) FROM cruise_holiday_surcharge 
   WHERE cruise_name = '라이라 그랜져 크루즈' AND schedule_type = '2N3D') as "휴일추가행";
```

**예상 결과**: 객실 33행

### 6.5 엑스트라베드 가능 객실 확인

```sql
SELECT 
  season_name as "시즌",
  COUNT(*) as "객실수"
FROM cruise_rate_card
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND schedule_type = '2N3D'
  AND extra_bed_available = true
GROUP BY season_name
ORDER BY season_name;
```

**예상 결과**: 3행 (시즌별 4개 객실)

### 6.6 정원제 객실 확인

```sql
SELECT 
  season_name as "시즌",
  COUNT(*) as "객실수"
FROM cruise_rate_card
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND schedule_type = '2N3D'
  AND extra_bed_available = false
GROUP BY season_name
ORDER BY season_name;
```

**예상 결과**: 3행 (시즌별 7개 객실)

---

## 7. 배포 절차

1. **SQL 파일 실행**: `lyra-granjer-rate-card-2n3d.sql`
2. **검증 쿼리 실행**: Section 6의 쿼리들 순서대로 실행
3. **데이터 확인**:
   - ✓ 객실 가격행 33행 확인 (11 객실 × 3 시즌)
   - ✓ 시즌명이 정확히 표시되었는지 확인
   - ✓ 엑스트라베드 가능 객실 4개 × 3시즌 확인
   - ✓ 정원제 객실 7개 × 3시즌 확인
4. **완료**: 배포 로그 기록

---

**문서 버전**: 1.0  
**작성일**: 2026년 2월 21일  
**상태**: ✅ 배포 준비 완료
