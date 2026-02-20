#!/bin/bash
INPUT=$(cat)

TOOL=$(echo "$INPUT" | jq -r '.tool_name // "action"')
HINT=$(echo "$INPUT" | jq -r '
  .tool_input |
  if .file_path then (.file_path | split("/") | last)
  elif .description then .description
  elif .pattern then .pattern
  elif .query then .query
  else ""
  end' | cut -c1-40)

if [ -n "$HINT" ]; then
  MSG="$TOOL $HINT"
else
  MSG="$TOOL"
fi

terminal-notifier -title "Claude Code" -message "✨ $MSG" -sound default
