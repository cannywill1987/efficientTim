---
name: user-feedback-handler
description: Use this skill when the user wants to process app user feedback from `CommentModel` / `timehello.comments` one by one, inspect the related code path, confirm the proposed fix before editing code, then update MongoDB feedback status, refresh the unfinished feedback CSV/JSON, and prepare a reply in the user's language.
---

# User Feedback Handler

Use this skill for the full workflow of handling end-user feedback stored in `CommentModel` / MongoDB collection `timehello.comments`.

## When to use

- The user asks to list, inspect, or process feedback from `CommentModel`
- The user wants to resolve feedback items one by one
- The user wants MongoDB feedback status and exported unfinished lists kept in sync

## Mandatory rule

Before **any code edit**, you must first:

1. identify the exact feedback item
2. inspect the relevant code path
3. summarize the likely fix in 2-6 lines
4. explicitly ask for confirmation

Do not edit code until the user confirms.

## Workflow

1. Read the target feedback item from MongoDB `timehello.comments`.
2. Decide whether it is:
   - bug
   - feature request
   - UX suggestion
   - unsupported / wrong-repo issue
3. Inspect the real code path before proposing a change.
4. Send the user a short confirmation summary before editing.
5. After approval, implement the code change.
6. Validate the touched area as much as possible.
7. Update the matching feedback document in MongoDB to the correct status.
   - default completed status: `status = 3`
8. Refresh unfinished feedback exports:
   - `/tmp/comments_unfinished_feedback.csv`
   - `/tmp/comments_unfinished_feedback.json`
9. Generate a short user-facing reply in the feedback's language.

## MongoDB handling

- Prefer read-first investigation.
- Use the local TimeHello MongoDB workflow and scripts already available in this environment.
- When updating status, target the exact `_id`.
- If `_id` string matching fails, retry with `ObjectId(...)`.

## Repo routing

- If the feedback is clearly server-side, inspect the Egg backend repo first:
  `/Users/linzhibin/Desktop/work/project/bff/code/trunk2/trunk/egg`
- If the feedback belongs to another app/repo and the code is not present here, stop and tell the user the current repo does not contain the implementation. Ask for the correct repo path before editing.

## Output rules

For each handled feedback item, report:

- what the feedback means
- what was changed
- whether MongoDB status was updated
- the new unfinished feedback count
- the reply text for the end user

## Reply template

The end-user reply should normally include:

1. the issue has been fixed / improved
2. how to use or where to find it
3. thanks for the suggestion or report

Match the user's language from the feedback when possible. If uncertain, infer from the feedback text itself.
