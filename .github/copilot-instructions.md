# Copilot Instructions for AI Agents

## ⚠️ 멀티 프로젝트 수정 필수 규칙 (2026.04.25 업데이트)
### 동시 수정 및 푸시 필수
**이 정책을 무시하면 프로젝트 간 동기화 불일치 발생:**
- ✅ **모든 수정은 2개 프로젝트에 동일하게 적용**: c:\SHT-DATA\sht-platform + c:\SHT-DATA\customer
- ✅ **커밋 후 반드시 모두 푸시**: 한 프로젝트만 푸시 금지
  ```bash
  # ❌ 금지: 한 프로젝트만 푸시
  cd c:\SHT-DATA\customer && git push
  
  # ✅ 필수: 두 프로젝트 모두 푸시
  cd c:\SHT-DATA\sht-platform && git push
  cd c:\SHT-DATA\customer && git push
  ```

### 수정 작업 체크리스트
- [ ] sht-platform에서 파일 수정 후 커밋
- [ ] customer에서 동일 파일 수정 후 커밋
- [ ] 둘 다 `git push` 실행 (푸시 전 `git log -1`으로 커밋 확인)
- [ ] **절대 한 프로젝트만 푸시하면 안 됨**

### 예시
```bash
# 1. sht-platform 수정
cd c:\SHT-DATA\sht-platform
# ... 파일 수정 ...
git add .
git commit -m "feat: add feature"
git log --oneline -1  # 커밋 번호 확인

# 2. customer 수정 (동일 내용)
cd c:\SHT-DATA\customer
# ... 동일 파일 수정 ...
git add .
git commit -m "feat: add feature"
git log --oneline -1  # 커밋 번호 확인

# 3. 둘 다 푸시
cd c:\SHT-DATA\sht-platform && git push && echo "✅ sht-platform pushed"
cd c:\SHT-DATA\customer && git push && echo "✅ customer pushed"
```

## 프로젝트 개요
**스테이하롱 크루즈 예약 시스템** - Next.js 15.3.5 App Router + Supabase PostgreSQL 기반 견적/예약 관리 웹앱.

## 핵심 아키텍처

### 사용자 역할 시스템
- **견적자 (Guest)**: Supabase 인증만, users 테이블 미등록. 견적 생성/조회만 가능
- **예약자 (Member)**: 예약 시 users 테이블 등록 (`role: 'member'`), 예약 관리 권한
- **매니저 (Manager)**: `role: 'manager'`, 견적 승인/예약 처리
- **관리자 (Admin)**: `role: 'admin'`, 시스템 전체 관리

### 데이터베이스 구조
- **중앙 모델**: `quote` → `quote_item` → 서비스 테이블 (`room`, `car`, `airport`, `hotel`, `rentcar`, `tour`)
- **예약 구조**: `reservation` (메인) → `reservation_*` (서비스별 상세: `reservation_cruise`, `reservation_airport` 등)
- **가격 시스템**: `*_price` 테이블 (room_price, car_price 등)로 동적 가격 계산
