-- ============================================================
-- 예약 통계 시스템 테이블 생성
-- 1. reservation_daily_stats: 일별 서비스별/상태별 예약 건수 스냅샷
-- 2. reservation_status_log: 예약 상태 변경 이력 로그
-- ============================================================

-- 1. 일별 예약 통계 테이블
CREATE TABLE IF NOT EXISTS reservation_daily_stats (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    stat_date date NOT NULL,
    service_type text NOT NULL,   -- cruise, airport, hotel, tour, rentcar, sht, car
    status text NOT NULL,         -- pending, approved, confirmed, completed, cancelled
    count integer NOT NULL DEFAULT 0,
    created_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE(stat_date, service_type, status)
);

-- 2. 예약 상태 변경 로그 테이블
CREATE TABLE IF NOT EXISTS reservation_status_log (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    reservation_id uuid NOT NULL,
    re_type text,                 -- 서비스 타입 (cruise, airport 등)
    prev_status text,             -- 이전 상태
    new_status text NOT NULL,     -- 변경된 상태
    changed_by uuid,              -- 변경한 매니저 user id
    changed_by_email text,        -- 변경한 매니저 이메일
    changed_at timestamptz NOT NULL DEFAULT now(),
    note text                     -- 메모 (일괄처리, 자동완료 등)
);

-- 인덱스
CREATE INDEX IF NOT EXISTS idx_daily_stats_date ON reservation_daily_stats(stat_date);
CREATE INDEX IF NOT EXISTS idx_daily_stats_service_type ON reservation_daily_stats(service_type);
CREATE INDEX IF NOT EXISTS idx_daily_stats_date_service ON reservation_daily_stats(stat_date, service_type);

CREATE INDEX IF NOT EXISTS idx_status_log_reservation ON reservation_status_log(reservation_id);
CREATE INDEX IF NOT EXISTS idx_status_log_changed_at ON reservation_status_log(changed_at DESC);
CREATE INDEX IF NOT EXISTS idx_status_log_changed_by ON reservation_status_log(changed_by);
CREATE INDEX IF NOT EXISTS idx_status_log_re_type ON reservation_status_log(re_type);

-- RLS 활성화
ALTER TABLE reservation_daily_stats ENABLE ROW LEVEL SECURITY;
ALTER TABLE reservation_status_log ENABLE ROW LEVEL SECURITY;

-- RLS 정책: 인증된 사용자 읽기/쓰기 허용
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'daily_stats_select' AND tablename = 'reservation_daily_stats') THEN
        CREATE POLICY daily_stats_select ON reservation_daily_stats FOR SELECT TO authenticated USING (true);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'daily_stats_insert' AND tablename = 'reservation_daily_stats') THEN
        CREATE POLICY daily_stats_insert ON reservation_daily_stats FOR INSERT TO authenticated WITH CHECK (true);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'status_log_select' AND tablename = 'reservation_status_log') THEN
        CREATE POLICY status_log_select ON reservation_status_log FOR SELECT TO authenticated USING (true);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'status_log_insert' AND tablename = 'reservation_status_log') THEN
        CREATE POLICY status_log_insert ON reservation_status_log FOR INSERT TO authenticated WITH CHECK (true);
    END IF;
END $$;

-- ============================================================
-- 검증 쿼리 (실행 후 확인용)
-- ============================================================
-- SELECT table_name FROM information_schema.tables WHERE table_name IN ('reservation_daily_stats', 'reservation_status_log');
-- SELECT indexname FROM pg_indexes WHERE tablename IN ('reservation_daily_stats', 'reservation_status_log');
