---
name: jira-ticket
description: Load and analyze QuizPlease Jira Server tickets before repository work. Use in the QuizPlease repository when a request names an MA issue key such as MA-36, says "задача 36" or "ticket 36", asks to implement or investigate a Jira task, or needs ticket acceptance criteria and context.
---

# Jira Ticket

Use the project-scoped `quizplease_jira` MCP server. Treat Jira as read-only.

## Resolve the ticket key

- Preserve an explicit `MA-N` key and normalize it to uppercase.
- Convert phrases such as `задача 36`, `таска 36`, or `ticket 36` to `MA-36`.
- Do not interpret an unrelated bare number as a Jira ticket.
- Reject keys from projects other than `MA`; this integration is scoped to QuizPlease Mobile.

## Load context before coding

1. Call `jira_get_issue` for the resolved key before planning or changing files. Request the richest supported field set and expansions, including rendered fields, transitions, and changelog when accepted by the tool.
2. If the issue contains parent, subtask, or linked `MA-*` keys that materially affect implementation, fetch those issues too.
3. Use `jira_search_fields` only when custom field identifiers are unclear. Use `jira_search` only for supporting `MA` issues and deterministic JQL with `ORDER BY`.
4. Extract the summary, type, status, priority, assignee, description, acceptance criteria, comments, links, dependencies, and implementation constraints that are actually present. Do not invent missing fields.
5. Briefly state any ambiguity or conflict between Jira and the repository before implementation.

If Jira tools are unavailable or authentication fails, stop the ticket-dependent work and tell the user to finish the local MCP setup. Do not scrape Jira through a browser as a fallback.

## Apply repository workflow

- For implementation work, create or use `feature/<ISSUE-KEY>` as required by `AGENTS.md`.
- Keep the ticket key in relevant commit messages.
- Run the focused tests required by the change.
- Do not transition issues, add comments, log work, or otherwise modify Jira.

## Protect credentials

- Never open, print, summarize, or modify `.codex/jira.env`.
- Never expose `JIRA_PERSONAL_TOKEN` in commands, logs, patches, or responses.
