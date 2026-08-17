#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ENV_FILE="$SCRIPT_DIR/jira.env"

if [ ! -r "$ENV_FILE" ]; then
  echo "QuizPlease Jira MCP is not configured: copy .codex/jira.env.example to .codex/jira.env and add a Jira Personal Access Token." >&2
  exit 1
fi

export JIRA_URL="https://jira.quizplease.ru"
export JIRA_SSL_VERIFY="true"
export JIRA_PROJECTS_FILTER="MA"
export READ_ONLY_MODE="true"
export TOOLSETS="jira_issues,jira_fields,jira_transitions,jira_worklog,jira_users"
export ENABLED_TOOLS="jira_get_user_profile,jira_get_issue,jira_search,jira_search_fields,jira_get_project_issues,jira_get_transitions,jira_get_worklog"
export MCP_ALLOWED_URL_DOMAINS="jira.quizplease.ru"

exec /opt/homebrew/bin/uvx --from "mcp-atlassian==0.23.0" mcp-atlassian --env-file "$ENV_FILE"
