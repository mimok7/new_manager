-- ⚠️ 기존 RLS 정책을 모두 제거하고 올바른 정책으로 재생성
-- Supabase SQL Editor에서 실행하세요

-- 1. 기존 quote 테이블 정책 제거
DROP POLICY IF EXISTS "Users can view own quotes" ON quote;
DROP POLICY IF EXISTS "Users can insert own quotes" ON quote;
DROP POLICY IF EXISTS "Users can update own quotes" ON quote;
DROP POLICY IF EXISTS "Users can delete own quotes" ON quote;
DROP POLICY IF EXISTS "Allow authenticated users to view quotes" ON quote;
DROP POLICY IF EXISTS "Allow authenticated users to create quotes" ON quote;
DROP POLICY IF EXISTS "Allow users to update own quotes" ON quote;

-- 2. 올바른 정책 재생성 (user_id 기준)
CREATE POLICY "Users can view own quotes" ON quote 
FOR SELECT 
USING (auth.uid()::text = user_id::text);

CREATE POLICY "Users can insert own quotes" ON quote 
FOR INSERT 
WITH CHECK (auth.uid()::text = user_id::text);

CREATE POLICY "Users can update own quotes" ON quote 
FOR UPDATE 
USING (auth.uid()::text = user_id::text);

CREATE POLICY "Users can delete own quotes" ON quote 
FOR DELETE 
USING (auth.uid()::text = user_id::text);

-- 3. quote_item 테이블 정책도 확인 및 수정
DROP POLICY IF EXISTS "Users can view own quote items" ON quote_item;
DROP POLICY IF EXISTS "Users can insert own quote items" ON quote_item;
DROP POLICY IF EXISTS "Users can update own quote items" ON quote_item;
DROP POLICY IF EXISTS "Users can delete own quote items" ON quote_item;

CREATE POLICY "Users can view own quote items" ON quote_item 
FOR SELECT 
USING (
  EXISTS (
    SELECT 1 FROM quote 
    WHERE quote.id = quote_item.quote_id 
      AND quote.user_id::text = auth.uid()::text
  )
);

CREATE POLICY "Users can insert own quote items" ON quote_item 
FOR INSERT 
WITH CHECK (
  EXISTS (
    SELECT 1 FROM quote 
    WHERE quote.id = quote_item.quote_id 
      AND quote.user_id::text = auth.uid()::text
  )
);

CREATE POLICY "Users can update own quote items" ON quote_item 
FOR UPDATE 
USING (
  EXISTS (
    SELECT 1 FROM quote 
    WHERE quote.id = quote_item.quote_id 
      AND quote.user_id::text = auth.uid()::text
  )
);

CREATE POLICY "Users can delete own quote items" ON quote_item 
FOR DELETE 
USING (
  EXISTS (
    SELECT 1 FROM quote 
    WHERE quote.id = quote_item.quote_id 
      AND quote.user_id::text = auth.uid()::text
  )
);

-- 결과 확인
SELECT 
    schemaname,
    tablename,
    policyname,
    cmd
FROM pg_policies 
WHERE tablename IN ('quote', 'quote_item')
ORDER BY tablename, policyname;
