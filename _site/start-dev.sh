#!/usr/bin/env bash
# start-dev.sh — Start Jekyll dev server and Tailwind CSS watch process.

set -euo pipefail

# ── Colour helpers ────────────────────────────────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
RESET='\033[0m'

# ── Track child PIDs ──────────────────────────────────────────────────────────
JEKYLL_PID=""
NPM_PID=""

# ── Cleanup on exit / interrupt ───────────────────────────────────────────────
cleanup() {
  echo -e "\n${YELLOW}Shutting down development servers…${RESET}"

  if [[ -n "$JEKYLL_PID" ]] && kill -0 "$JEKYLL_PID" 2>/dev/null; then
    echo -e "  ${RED}✗${RESET} Stopping Jekyll (PID $JEKYLL_PID)"
    kill "$JEKYLL_PID" 2>/dev/null || true
  fi

  if [[ -n "$NPM_PID" ]] && kill -0 "$NPM_PID" 2>/dev/null; then
    echo -e "  ${RED}✗${RESET} Stopping npm watch (PID $NPM_PID)"
    kill "$NPM_PID" 2>/dev/null || true
  fi

  wait 2>/dev/null || true
  echo -e "${GREEN}Done.${RESET}"
}

trap cleanup EXIT INT TERM

# ── Preflight checks ──────────────────────────────────────────────────────────
if ! command -v bundle &>/dev/null; then
  echo -e "${RED}Error:${RESET} 'bundle' not found. Install Bundler: gem install bundler" >&2
  exit 1
fi

if ! command -v npm &>/dev/null; then
  echo -e "${RED}Error:${RESET} 'npm' not found. Install Node.js from https://nodejs.org" >&2
  exit 1
fi

# ── Start processes ───────────────────────────────────────────────────────────
echo -e "${GREEN}Starting Tailwind CSS watch…${RESET}"
npm run watch &
NPM_PID=$!

echo -e "${GREEN}Starting Jekyll development server…${RESET}"
bundle exec jekyll serve --livereload &
JEKYLL_PID=$!

echo -e "\n${GREEN}✓${RESET} Both processes running."
echo -e "  Jekyll PID : ${JEKYLL_PID}"
echo -e "  npm PID    : ${NPM_PID}"
echo -e "\n  Site will be available at ${YELLOW}http://localhost:4000${RESET}"
echo -e "  Press ${YELLOW}Ctrl+C${RESET} to stop.\n"

# ── Wait — exit if either child dies unexpectedly ────────────────────────────
wait -n 2>/dev/null || {
  # wait -n may not be available in older bash; fall back to polling
  while kill -0 "$JEKYLL_PID" 2>/dev/null && kill -0 "$NPM_PID" 2>/dev/null; do
    sleep 2
  done
}
