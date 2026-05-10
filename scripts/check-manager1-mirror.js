const { execSync } = require('child_process');
const fs = require('fs');

function getStagedFiles() {
  try {
    const out = execSync('git diff --cached --name-only', { encoding: 'utf8' });
    return out.split('\n').map(s => s.trim()).filter(Boolean);
  } catch (e) {
    console.error('git diff failed:', e.message);
    process.exit(2);
  }
}

function mapToManager1(path) {
  if (path.startsWith('apps/manager/src/')) return path.replace('apps/manager/src/', 'apps/manager1/');
  if (path.startsWith('apps/manager/')) return path.replace('apps/manager/', 'apps/manager1/');
  return null;
}

const staged = getStagedFiles();
const stagedSet = new Set(staged);

const errors = [];
for (const p of staged) {
  if (!p.startsWith('apps/manager/')) continue;
  const candidate = mapToManager1(p);
  if (!candidate) continue;
  if (fs.existsSync(candidate)) {
    // counterpart exists — ensure it's also staged (modified/deleted/added)
    if (!stagedSet.has(candidate)) {
      errors.push({ file: p, counterpart: candidate });
    }
  }
}

if (errors.length) {
  console.error('\n[check:manager1-mirror] 오류: `apps/manager`에서 변경된 파일과 동일 경로의 `apps/manager1` 파일이 존재합니다.');
  console.error('`apps/manager1`에 해당 파일이 있는 경우 동일한 변경을 함께 포함시켜 커밋해야 합니다.\n');
  errors.forEach(e => console.error(` - ${e.file}  -> ${e.counterpart}`));
  console.error('\n커밋을 중단합니다. 변경을 `apps/manager1`에도 적용하거나, 해당 파일을 명시적으로 무시하려면 유지보수 규칙에 따라 PR 설명에 근거를 남기세요.');
  process.exit(1);
}

console.log('[check:manager1-mirror] OK — no mirror violations found.');
process.exit(0);
