-- 011-airport-names-data.sql
-- 공항명 테이블 생성 및 기본 공항명 데이터 삽입

CREATE TABLE IF NOT EXISTS airport_name (
  airport_id BIGSERIAL PRIMARY KEY,
  airport_code TEXT UNIQUE NOT NULL,
  airport_name TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

INSERT INTO airport_name (airport_code, airport_name) VALUES
  ('NOI_INT', '노이바이 공항 국제선'),
  ('NOI_DOM', '노이바이 공항 국내선'),
  ('CAT_INT', '캇비공항 국제선'),
  ('CAT_DOM', '캇비공항 국내선')
ON CONFLICT (airport_code) DO NOTHING;

-- 검증용 조회
-- SELECT * FROM airport_name ORDER BY airport_id;
