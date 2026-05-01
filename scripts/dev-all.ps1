<#
Opens a new PowerShell window for each app and runs its pnpm dev command.
Run from repo root with: `powershell -ExecutionPolicy Bypass -File scripts\dev-all.ps1`
#>

$root = Split-Path -Parent $MyInvocation.MyCommand.Path

if (-not (Get-Command pnpm -ErrorAction SilentlyContinue)) {
    Write-Host "pnpm이 설치되어 있지 않습니다. 'corepack enable' 또는 'npm i -g pnpm'로 설치하세요." -ForegroundColor Yellow
    exit 1
}

$apps = @(
    @{ name='manager'; path='apps/manager'; filter='@sht/manager' },
    @{ name='customer'; path='apps/customer'; filter='@sht/customer' },
    @{ name='quote'; path='apps/quote'; filter='@sht/quote' },
    @{ name='manager1'; path='apps/manager1'; filter='@sht/manager1' },
    @{ name='admin'; path='apps/admin'; filter='@sht/admin' },
    @{ name='partner'; path='apps/partner'; filter='@sht/partner' },
    @{ name='customer1'; path='apps/customer1'; filter='@sht/customer1' }
)

foreach ($app in $apps) {
    $appDir = Join-Path $root $app.path
    if (-not (Test-Path $appDir)) {
        Write-Host "경로 없음: $appDir — 건너뜁니다." -ForegroundColor DarkYellow
        continue
    }
    $cmd = "cd `"$appDir`"; pnpm --filter $($app.filter) dev"
    Start-Process -FilePath "powershell" -ArgumentList "-NoExit","-Command",$cmd -WindowStyle Normal
    Start-Sleep -Milliseconds 200
}

Write-Host "모든 앱 창을 열었습니다. 각 창에서 로그를 확인하세요." -ForegroundColor Green
