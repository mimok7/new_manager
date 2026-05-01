<#
Opens two PowerShell windows and runs pnpm dev for manager and manager1.
Usage: from repo root
  powershell -ExecutionPolicy Bypass -File scripts\dev-managers.ps1
#>

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
# repo 루트는 스크립트의 한 단계 상위 폴더로 가정
$root = Split-Path -Parent $scriptDir

# 콘솔 인코딩을 UTF-8로 설정하여 한글 깨짐 방지
try {
    chcp 65001 | Out-Null
} catch { }
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

if (-not (Get-Command pnpm -ErrorAction SilentlyContinue)) {
    Write-Host "pnpm이 설치되어 있지 않습니다. 'corepack enable' 또는 'npm i -g pnpm'로 설치하세요." -ForegroundColor Yellow
    exit 1
}

$apps = @(
    @{ name='manager'; path='apps/manager'; filter='@sht/manager' },
    @{ name='manager1'; path='apps/manager1'; filter='@sht/manager1' }
)

foreach ($app in $apps) {
    $appDir = Join-Path $root $app.path
    if (-not (Test-Path $appDir)) {
        Write-Host "경로 없음: $appDir — 건너뜁니다." -ForegroundColor DarkYellow
        continue
    }
    # 각 새 창에서 먼저 코드페이지/출력 인코딩을 설정하도록 명령어에 포함
    $cmd = "chcp 65001; `[Console]::OutputEncoding = [System.Text.Encoding]::UTF8` ; `$OutputEncoding = [System.Text.Encoding]::UTF8 ; cd `"$appDir`"; pnpm --filter $($app.filter) dev"
    Start-Process -FilePath "powershell" -ArgumentList "-NoExit","-Command",$cmd -WindowStyle Normal
    Start-Sleep -Milliseconds 200
}

Write-Host "매니저 앱 창을 열었습니다. 각 창에서 로그를 확인하세요." -ForegroundColor Green
