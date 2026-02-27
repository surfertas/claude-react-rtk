#!/usr/bin/env bash
# SessionStart hook: Check if a React dev server is running
# Checks common ports: Next.js/CRA (3000), Vite (5173), Webpack (8080)

for PORT in 3000 5173 8080; do
  STATUS=$(curl -s --connect-timeout 1 -o /dev/null -w "%{http_code}" "http://localhost:$PORT" 2>/dev/null)
  if [ "$STATUS" != "000" ]; then
    echo "Dev server detected on localhost:$PORT"
    exit 0
  fi
done
