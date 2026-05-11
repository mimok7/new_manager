<#
백업 후 apps/*의 cruisePriceCalculator 파일을 공용 모듈 래퍼로 교체합니다.
실행 전 반드시 `git status`로 변경사항을 확인하세요.
#>

$files = @( 
  'apps\admin\lib\cruisePriceCalculator.ts',
  'apps\quote\lib\cruisePriceCalculator.ts',
  'apps\customer\src\lib\cruisePriceCalculator.ts',
  'apps\customer1\lib\cruisePriceCalculator.ts',
  'apps\manager\src\lib\cruisePriceCalculator.ts',
  'apps\manager1\lib\cruisePriceCalculator.ts'
)

$wrapper = @'
/**
 * 중앙 가격 계산 모듈 래퍼.
 * 실제 구현은 packages/domain/src/pricing 에서 관리됩니다.
 */
export * from "@sht/domain/pricing";
'@

foreach ($f in $files) {
  $path = Join-Path $PSScriptRoot "..\$f" | Resolve-Path -ErrorAction SilentlyContinue
  if (-not $path) { Write-Host "파일 없음: $f"; continue }
  $full = $path.ToString()
  $bak = "$full.bak"
  if (-not (Test-Path $bak)) { Copy-Item -Path $full -Destination $bak -Force; Write-Host "백업 생성: $bak" }
  Set-Content -Path $full -Value $wrapper -Encoding UTF8
  Write-Host "교체 완료: $full"
}

Write-Host "완료. 변경사항을 확인하려면 'git status'를 실행하세요."