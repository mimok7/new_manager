import preset from '@sht/config/tailwind/preset.js';

/** @type {import('tailwindcss').Config} */
export default {
  presets: [preset],
  content: [
    './src/**/*.{ts,tsx}',
    '../../packages/ui/src/**/*.{ts,tsx}',
  ],
  theme: { extend: {} },
  plugins: [],
};
