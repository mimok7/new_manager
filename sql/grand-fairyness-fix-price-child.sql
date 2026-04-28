-- ============================================================================
-- Grand Fairyness Cruise - Price Child Fix & Verification
-- 그랜드 파이어니스 크루즈 - 아동요금(price_child) 누락 수정 및 검증
-- ============================================================================

-- ============================================================================
-- Step 1: 현재 상태 확인 (아동요금 NULL인 행 확인)
-- ============================================================================

SELECT 'Step 1: 아동요금 NULL인 행 확인' AS status;

SELECT
  schedule_type as "시즌",
  room_type as "객실명",
  price_adult as "성인",
  price_child as "아동 (현재)",
  price_extra_bed as "엑스트라",
  price_child_extra_bed as "아동엑스트라",
  price_single as "싱글"
FROM cruise_rate_card
WHERE cruise_name = '그랜드 파이어니스 크루즈'
  AND (price_child IS NULL OR price_child = 0)
ORDER BY schedule_type, room_type;

-- ============================================================================
-- Step 2: 아동요금 UPDATE (누락된 값 입력)
-- ============================================================================

BEGIN;

-- 시즌1 (1N2D-S1): 아동 기본값 3,200,000 (보통 객실)
UPDATE cruise_rate_card
SET price_child = 3200000
WHERE cruise_name = '그랜드 파이어니스 크루즈'
  AND schedule_type = '1N2D-S1'
  AND room_type NOT IN ('오션스위트 트리플룸', '더 에센스 스위트', '더 오셔니아 스위트')
  AND (price_child IS NULL OR price_child = 0);

-- 시즌2 (1N2D-S2): 아동 기본값 3,150,000 (보통 객실) - 단, 럭셔리는 보존
UPDATE cruise_rate_card
SET price_child = 3150000
WHERE cruise_name = '그랜드 파이어니스 크루즈'
  AND schedule_type = '1N2D-S2'
  AND room_type NOT IN ('오션스위트 트리플룸', '더 오셔니아 스위트')  -- 럭셔리 제외
  AND price_child != 3200000  -- 럭셔리 (에센스는 3,200,000 유지)
  AND (price_child IS NULL OR price_child = 0);

COMMIT;

-- ============================================================================
-- Step 3: 수정 결과 전체 확인 (시즌1)
-- ============================================================================

SELECT 'Step 3: 시즌1 수정 결과' AS status;

SELECT
  room_type as "객실명",
  price_adult as "성인",
  price_child as "아동",
  price_extra_bed as "엑스트라베드",
  price_child_extra_bed as "아동엑스트라",
  price_single as "싱글차지"
FROM cruise_rate_card
WHERE cruise_name = '그랜드 파이어니스 크루즈'
  AND schedule_type = '1N2D-S1'
ORDER BY room_type;

-- ============================================================================
-- Step 4: 수정 결과 전체 확인 (시즌2)
-- ============================================================================

SELECT 'Step 4: 시즌2 수정 결과' AS status;

SELECT
  room_type as "객실명",
  price_adult as "성인",
  price_child as "아동",
  price_extra_bed as "엑스트라베드",
  price_child_extra_bed as "아동엑스트라",
  price_single as "싱글차지"
FROM cruise_rate_card
WHERE cruise_name = '그랜드 파이어니스 크루즈'
  AND schedule_type = '1N2D-S2'
ORDER BY room_type;

-- ============================================================================
-- Step 5: 최종 검증 (아동요금 NULL인 행이 남아있는지 확인)
-- ============================================================================

SELECT 'Step 5: 최종 검증 - NULL 여부' AS status;

SELECT
  CASE 
    WHEN COUNT(*) = 0 THEN '✅ 모든 아동요금 입력 완료'
    ELSE '⚠️ 여전히 NULL인 행 있음: ' || COUNT(*) || '개'
  END as 검증결과
FROM cruise_rate_card
WHERE cruise_name = '그랜드 파이어니스 크루즈'
  AND price_child IS NULL;

-- ============================================================================
-- Step 6: 정상적으로 NULL이어야 하는 객실들 확인
-- ============================================================================

SELECT 'Step 6: 아동 불가 객실 (정상 NULL)' AS status;

SELECT
  schedule_type as "시즌",
  room_type as "객실명",
  price_adult as "성인",
  price_child as "아동 (NULL = 정상)"
FROM cruise_rate_card
WHERE cruise_name = '그랜드 파이어니스 크루즈'
  AND price_child IS NULL
ORDER BY schedule_type, room_type;
