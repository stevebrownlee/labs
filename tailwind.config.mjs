/** @type {import('tailwindcss').Config} */
export default {
  content: ['./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}'],
  theme: {
    extend: {
      colors: {
        indigo: {
          950: '#0f0a2e',
          900: '#1a0f4e',
          800: '#2d1b88',
          700: '#3d2db5',
          600: '#4f3fd4',
          500: '#6b5ef0',
          400: '#8b7ff5',
          300: '#b0a8f9',
        },
      },
      fontFamily: {
        display: ['Fraunces', 'Georgia', 'serif'],
        sans: ['Inter', 'system-ui', 'sans-serif'],
        mono: ['JetBrains Mono', 'monospace'],
      },
    },
  },
  plugins: [],
};
