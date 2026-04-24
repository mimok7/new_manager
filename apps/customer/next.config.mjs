import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  typedRoutes: false,
  transpilePackages: ['@sht/ui', '@sht/auth', '@sht/db', '@sht/domain', '@sht/types'],
  outputFileTracingRoot: path.join(__dirname, '../../'),
};

export default nextConfig;
