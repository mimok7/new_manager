/** Shared ESLint config (Flat) */
const tseslint = require('typescript-eslint');
const next = require('@next/eslint-plugin-next');

module.exports = tseslint.config(
  {
    ignores: ['**/.next/**', '**/dist/**', '**/build/**', '**/node_modules/**'],
  },
  ...tseslint.configs.recommended,
  {
    plugins: { '@next/next': next },
    rules: {
      ...next.configs.recommended.rules,
      ...next.configs['core-web-vitals'].rules,
      '@typescript-eslint/no-explicit-any': 'warn',
      '@typescript-eslint/no-unused-vars': ['warn', { argsIgnorePattern: '^_' }],
    },
  },
);
