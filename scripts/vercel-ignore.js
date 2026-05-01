#!/usr/bin/env node

/**
 * Vercel ignoreCommand script
 * Returns exit code 0 (ignore/skip) if no changes in the app directory
 * Returns exit code 1 (deploy) if there are changes
 */

const { execSync } = require('child_process');

// Get app name from environment or command line
const appName = process.argv[2] || process.env.APP_NAME;

if (!appName) {
  console.error('❌ APP_NAME not specified');
  process.exit(1);
}

try {
  // Check if there are changes in the app directory
  const output = execSync(
    `git diff --quiet HEAD~1 HEAD -- apps/${appName}`,
    { encoding: 'utf-8', stdio: 'pipe' }
  );
  
  // If command succeeded (exit 0), no changes detected → skip build
  console.log(`✅ No changes in apps/${appName} - skipping build`);
  process.exit(0);
} catch (error) {
  // If command failed (exit 1), changes detected → proceed with build
  console.log(`🔨 Changes detected in apps/${appName} - proceeding with build`);
  process.exit(1);
}
