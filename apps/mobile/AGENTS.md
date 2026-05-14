<!-- BEGIN:nextjs-agent-rules -->
# This is NOT the Next.js you know

This version has breaking changes — APIs, conventions, and file structure may all differ from your training data. Read the relevant guide in `node_modules/next/dist/docs/` before writing any code. Heed deprecation notices.
<!-- END:nextjs-agent-rules -->

## Mobile Project Working Instructions

모바일 프로젝트는 `sht-manager`의 기능을 그대로 복제하는 프로젝트가 아니라,
필요한 기능만 선별해 빠르게 구현하는 경량 프로젝트로 작업한다.

1. 매니저 프로젝트(`sht-manager`)를 참조하여 새로 코드를 작성한다.
2. 꼭 필요한 코드만 새로 작성한다.

### Implementation Principles

- 먼저 `sht-manager`에서 대상 기능의 핵심 흐름과 데이터 구조를 확인한다.
- 모바일 환경에 불필요한 관리자용 부가 로직, 복잡한 추상화, 과도한 UI 요소는 제외한다.
- 재사용보다 단순함을 우선하며, 동작에 필요한 최소 단위로 작성한다.
- 기능 추가 시 "모바일에서 지금 필요한가"를 먼저 검증하고, 필요 시에만 반영한다.
