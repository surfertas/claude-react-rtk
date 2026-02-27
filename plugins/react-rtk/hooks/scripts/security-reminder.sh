#!/usr/bin/env bash
# PostToolUse hook: Output React Security Iron Laws when security-sensitive files are edited
FILE_PATH=$(cat | jq -r '.tool_input.file_path // empty')
if [ -z "$FILE_PATH" ]; then
  exit 0
fi

BASENAME=$(basename "$FILE_PATH")

# Check if file path matches security-sensitive patterns
if echo "$FILE_PATH" | grep -qiE '(auth|login|token|apikey|secret|oauth|password|credential|session|permission|admin|payment)'; then
  echo "SECURITY FILE DETECTED: $BASENAME"
  echo "Iron Laws -- verify these apply:"
  echo "  #21: No dangerouslySetInnerHTML with untrusted content (DOMPurify required)"
  echo "  #22: No secrets in client bundle (no NEXT_PUBLIC_/VITE_ for keys/tokens)"
  echo "  #23: Sanitize all URL parameters used in state (useSearchParams, useParams)"
  echo "  #24: Every Server Action must verify authentication ('use server' = public endpoint)"
  echo "Consider: /rx:review --focus security for full security audit"
fi
