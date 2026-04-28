# Catherine Cruise (캐서린 크루즈) - Data Input Guideline

---

## 1. 프로젝트 개요

**크루즈명**: 캐서린 크루즈 (Catherine Cruise)  
**상품타입**: 1박 2일 (1N2D) & 2박 3일 (2N3D)  
**통화**: VND 베트남동  
**연도**: 2026년  
**시즌 구분**: 없음 (연중 동일 요금)

---

## 2. 객실 타입 및 요금 정보

### 2.1 1박 2일 (1N2D) - 객실 요금표

| 객실명 | 성인 (1인) | 아동 (1인) | 엑스트라베드 | 1인 싱글차지 | 추가가능 |
|--------|-----------|----------|-----------|----------|--------|
| 프리미어 스위트 (1층) | 5,300,000 | 3,300,000 | 4,700,000 | 8,450,000 | ✓ |
| 프리미어 스위트 트리플 (1층) | 5,300,000 | 3,300,000 | — | — | ✗ |
| 프리미어 스위트 (2층) | 5,600,000 | 3,300,000 | 5,000,000 | 8,900,000 | ✓ |
| 프리미어 스위트 (3층) | 5,800,000 | 3,300,000 | 5,250,000 | 9,350,000 | ✓ |
| 로얄 스위트 | 7,500,000 | 3,300,000 | 6,700,000 | 12,500,000 | ✓ |
| 그랜드 스위트 | 8,350,000 | 3,300,000 | 7,500,000 | 14,100,000 | ✓ |
| 빌라 프레지던트 | 15,800,000 | 3,500,000 | 14,200,000 | 29,150,000 | ✓ |

### 2.2 2박 3일 (2N3D) - 객실 요금표

| 객실명 | 성인 (1인) | 아동 (1인) | 엑스트라베드 | 1인 싱글차지 | 추가가능 |
|--------|-----------|----------|-----------|----------|--------|
| 프리미어 스위트 (1층) | 10,600,000 | 6,600,000 | 9,400,000 | 16,900,000 | ✓ |
| 프리미어 스위트 트리플 (1층) | 10,600,000 | 6,600,000 | — | — | ✗ |
| 프리미어 스위트 (2층) | 11,200,000 | 6,600,000 | 10,000,000 | 17,800,000 | ✓ |
| 프리미어 스위트 (3층) | 11,600,000 | 6,600,000 | 10,500,000 | 18,700,000 | ✓ |
| 로얄 스위트 | 15,000,000 | 6,600,000 | 13,400,000 | 25,000,000 | ✓ |
| 그랜드 스위트 | 16,700,000 | 6,600,000 | 15,000,000 | 28,200,000 | ✓ |
| 빌라 프레지던트 | 31,600,000 | 7,000,000 | 28,400,000 | 58,300,000 | ✓ |

### 2.3 추가 요금

**1박 2일 (1N2D) - 2번째 유아**
- 600,000동 (모든 객실 동일)

**2박 3일 (2N3D) - 2번째 유아**
- 1,200,000동 (모든 객실 동일)

**1박 2일 (1N2D) - 휴일 추가요금**
- 2026년 04월 30일 ~ 05월 01일 (황금연휴): +1,200,000동/인 (성인, 아동 동일)
- 2026년 12월 24일 (크리스마스): +1,200,000동/인 (성인, 아동 동일)
- 2026년 12월 31일 (연말): +1,200,000동/인 (성인, 아동 동일)

**2박 3일 (2N3D) - 휴일 추가요금**
- 2026년 12월 24일 (크리스마스): +1,500,000동/인 (성인, 아동 동일)
- 2026년 12월 31일 (연말): +1,500,000동/인 (성인, 아동 동일)

---

## 3. 데이터 구조

### 3.1 cruise_rate_card 테이블

**목적**: 기본 객실 요금 관리

| 컬럼 | 값 | 비고 |
|------|-----|------|
| cruise_name | 캐서린 크루즈 | 고정값 |
| schedule_type | 2N3D | 2박 3일 구분자 |
| room_type | 프리미어 스위트 (1층) 등 | 한글 객실명 |
| room_type_en | Premier Suite (1F) 등 | 영문 객실명 |
| price_adult | 10,600,000 | 성인 1인 요금 |
| price_child | 6,600,000 | 아동 1인 요금 (약 62%) |
| price_infant | 1,200,000 | 2번째 유아 요금 |
| price_extra_bed | 9,400,000 | 엑스트라베드 추가 요금 |
| price_child_extra_bed | 9,400,000 | 아동 엑스트라베드 |
| price_single | 16,900,000 | 1인 싱글차지 |
| extra_bed_available | true/false | 추가침 가능 여부 |
| valid_year | 2026 | 유효 연도 |
| valid_from | 2026-01-01 | 유효 시작일 |
| valid_to | 2026-12-31 | 유효 종료일 |
| currency | VND | 통화 |
| season_name | NULL | 시즌 구분 없음 |
| is_active | true | 활성화 상태 |

**총 행 수**: 7행 (객실 × 1 시즌)

### 3.2 cruise_holiday_surcharge 테이블

**목적**: 휴일 추가요금 관리

| 컬럼 | 값 | 비고 |
|------|-----|------|
| cruise_name | 캐서린 크루즈 | 고정값 |
| schedule_type | 2N3D | 2박 3일 구분자 |
| holiday_date | 2026-12-24 | 휴일 시작일 |
| holiday_date_end | NULL | 종료일 (당일 중복 방지 시 사용) |
| holiday_name | 크리스마스 | 휴일명 |
| surcharge_per_person | 1,500,000 | 성인 추가요금 |
| surcharge_child | 1,500,000 | 아동 추가요금 (성인과 동일) |
| surcharge_type | per_person | 개인당 합산 방식 |
| valid_year | 2026 | 유효 연도 |
| currency | VND | 통화 |
| is_confirmed | true | 확정 상태 |

**총 행 수**: 2행 (휴일)

---

## 4. 주요 특징 및 정책

### 4.1 객실별 특수 조건

- **프리미어 스위트 트리플 (1층)**: 
  - 기본 침대 3개 (엑스트라베드 불가)
  - price_extra_bed = NULL
  - extra_bed_available = false

- **빌라 프레지던트**:
  - 아동 요금이 7,000,000동으로 다른 객실과 상이
  - 나머지 객실 아동 요금: 6,600,000동 (일괄 적용)

### 4.2 요금 체계의 특징

- **연중 단일 시즌**: 시즌 구분 없이 year=2026인 전체 기간 동일 요금
- **아동 요금 통일**: 대부분 객실이 6,600,000동 (약 62%의 성인 요금)
- **유아 요금 보편성**: 모든 객실에서 1,200,000동 (기본 성인 요금의 약 11%)
- **트리플 객실**: 엑스트라베드 없음 (NULL 처리로 "추가불가" 표현)

### 4.3 1박 2일(1N2D) 데이터 보호

**중요**: SQL 파일의 DELETE 문은 `schedule_type = '2N3D'`로 필터링되어 있습니다.  
따라서 1박 2일(1N2D) 데이터는 **절대 영향을 받지 않습니다**.

```sql
-- 안전한 삭제: 2N3D만 대상
DELETE FROM cruise_rate_card 
WHERE cruise_name = '캐서린 크루즈' AND schedule_type = '2N3D';
```

---

## 5. 데이터베이스 매핑

### 5.1 입력 데이터 → DB 필드 매핑

| 입력값 | DB 필드 명 | 타입 | 예시 |
|--------|-----------|------|------|
| 객실명 | room_type | text | 프리미어 스위트 (1층) |
| 성인요금 | price_adult | integer | 10600000 |
| 아동요금 | price_child | integer | 6600000 |
| 2번째유아 | price_infant | integer | 1200000 |
| 엑스트라베드 | price_extra_bed | integer | 9400000 (NULL 불가 시) |
| 싱글차지 | price_single | integer | 16900000 |
| 추가가능여부 | extra_bed_available | boolean | true/false |

---

## 6. 검증 쿼리

### 6.1 전체 요금 확인

```sql
SELECT 
  room_type as "객실명",
  price_adult as "성인",
  price_child as "아동",
  price_infant as "2번째유아",
  price_extra_bed as "엑스트라베드",
  price_single as "싱글차지",
  CASE WHEN extra_bed_available THEN 'O' ELSE 'X' END as "추가가능"
FROM cruise_rate_card
WHERE cruise_name = '캐서린 크루즈'
  AND schedule_type = '2N3D'
ORDER BY room_type;
```

**예상 결과**: 7행

### 6.2 휴일 추가요금 확인

```sql
SELECT
  holiday_date as "날짜",
  holiday_name as "휴일명",
  surcharge_per_person as "성인추가요금",
  surcharge_child as "아동추가요금"
FROM cruise_holiday_surcharge
WHERE cruise_name = '캐서린 크루즈'
  AND schedule_type = '2N3D'
ORDER BY holiday_date;
```

**예상 결과**: 2행 (12/24, 12/31)

### 6.3 schedule_type 별 데이터 개수 확인

```sql
SELECT 
  schedule_type,
  COUNT(*) as "행 개수"
FROM cruise_rate_card
WHERE cruise_name = '캐서린 크루즈'
GROUP BY schedule_type;
```

**예상 결과**: 
- 2N3D: 7행
- (1N2D 있으면 별도로 표시)

---

## 7. 데이터 입력 절차

### 7.1 사전 체크리스트

- [ ] Supabase 접속 확인
- [ ] `cruise_rate_card` 테이블 존재 확인
- [ ] `cruise_holiday_surcharge` 테이블 존재 확인
- [ ] 기존 캐서린 크루즈 2N3D 데이터 백업 (필요시)

### 7.2 배포 단계

1. **SQL 파일 실행**
   - 파일: `catherine-rate-card-2n3d.sql`
   - 위치: sql 폴더
   - 방법: Supabase Dashboard SQL Editor 또는 command line

2. **데이터 검증**
   - Section 6의 검증 쿼리 실행
   - 행 개수 및 요금값 확인

3. **완료**
   - 모든 검증 쿼리 결과 정상 확인
   - 배포 로그 기록

---

## 8. 주의사항

### 8.1 NULL 처리 규칙

| 필드 | NULL 가능 | 항상 값 필요 | 비고 |
|------|----------|-----------|------|
| price_extra_bed | ✓ | ✗ | 엑스트라베드 불가능한 객실은 NULL |
| price_child_extra_bed | ✓ | ✗ | price_extra_bed=NULL일 때 NULL |
| price_single | ✓ | ✗ | 트리플 객실은 NULL 가능 |
| price_child | ✓ | ✓ | 모든 객실은 아동 요금 必須 |
| price_adult | — | ✓ | 반드시 필요 |

### 8.2 schedule_type 사용 규칙

```
schedule_type = '2N3D'    # Catherine Cruise 2박 3일
schedule_type = '1N2D'    # Catherine Cruise 1박 2일 (향후 추가 가능)
```

- **절대**: schedule_type 혼동으로 인한 데이터 손상
- **필수**: DELETE/INSERT 시 schedule_type 필터 적용
- **보호**: 위의 규칙 준수 시 1N2D 데이터는 안전

### 8.3 가격 단위

- **모든 가격**: VND (베트남동), 1동 단위
- **소수점**: 사용하지 않음 (정수만)
- **통화 기호**: 데이터에 포함하지 않음

---

## 9. 문제 해결 (Troubleshooting)

### 9.1 중복 데이터 발생 시

```sql
-- 중복 행 개수 확인
SELECT COUNT(*) FROM cruise_rate_card
WHERE cruise_name = '캐서린 크루즈' AND schedule_type = '2N3D';
-- 예상: 7행 (초과 시 중복)

-- 중복 삭제
DELETE FROM cruise_rate_card 
WHERE cruise_name = '캐서린 크루즈' AND schedule_type = '2N3D';

-- SQL 파일 재실행
```

### 9.2 아동 요금 누락 시

```sql
-- 빌라 프레지던트 확인 (7,000,000)
-- 나머지 모두 6,600,000 확인
SELECT DISTINCT price_child FROM cruise_rate_card
WHERE cruise_name = '캐서린 크루즈' AND schedule_type = '2N3D'
ORDER BY price_child;
```

### 9.3 1N2D 데이터 확인

```sql
-- 1N2D 데이터 존재 여부 확인
SELECT COUNT(*) FROM cruise_rate_card
WHERE cruise_name = '캐서린 크루즈' AND schedule_type = '1N2D';
-- 결과가 0이면 1N2D 없음, 0 초과면 1N2D 존재 (보호됨)
```

---

## 10. 추가 정보

### 10.1 파일 목록

| 파일명 | 목적 | 위치 |
|--------|------|------|
| catherine-rate-card-2n3d.sql | 2N3D 요금 데이터 | sql/ |
| CATHERINE-DATA-INPUT-GUIDELINE.md | 본 문서 | sql/ |

### 10.2 다른 크루즈와의 비교

| 크루즈 | 시즌수 | 객실수 | 특징 |
|--------|--------|--------|------|
| 캐서린 | 1 | 7 | 자체 아동요금, 트리플 객실 특수 |
| 칼리스타 2N3D | 3 | 6 | 다중 시즌, 통일된 아동요금 |
| 그랜드페어니스 | 2 | 10 | 다중 시즌, 높은 가격대 |
| 헤르메스 | 2 | 8 | 다중 시즌, 휴일 아동 차감 |

---

**문서 버전**: 1.0  
**작성일**: 2026년 2월 21일  
**마지막 수정**: 2026년 2월 21일
