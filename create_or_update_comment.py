from github import Github
import os

g = Github(os.getenv("GITHUB_TOKEN"))
pr_id = int(os.getenv("INPUT_PR"))
repo_id = os.getenv("GITHUB_REPOSITORY")
action = os.getenv("INPUT_ACTION")
deployment_name = os.getenv("DEPLOYMENT_NAME")

repo = g.get_repo(repo_id)
pr = repo.get_pull(pr_id)

comments = pr.get_issue_comments()
comment_to_update = None
for comment in comments:
    if comment.user.login == "github-actions[bot]" and "Dagster Cloud" in comment.body:
        comment_to_update = comment
        break

SUCCESS_IMAGE = """
<img
    alt="build succeeded"
    src="https://raw.githubusercontent.com/dagster-io/dagster/9842ba843d281146ab0242be96e2c6301f5e42c9/js_modules/dagit/packages/app/public/favicon-run-success.svg"
    width=25
    height=25
/>
"""

BUILDING_IMAGE = """
<img
    alt="build succeeded"
    src="https://raw.githubusercontent.com/dagster-io/dagster/9842ba843d281146ab0242be96e2c6301f5e42c9/js_modules/dagit/packages/app/public/favicon-run-pending.svg"
    width=25
    height=25
/>
"""

deployment_url = f"https://7151-136-24-32-204.ngrok.io/1/{deployment_name}/"

status_image = (SUCCESS_IMAGE if action == "complete" else BUILDING_IMAGE).replace("\n", " ")
message = f"""
Your pull request is automatically being deployed to Dagster Cloud.

| Location      | Status          | Link              |
| ------------- | --------------- | ----------------- |
| `my_location` | {status_image}  | {deployment_url}  |
"""

if comment_to_update:
    comment_to_update.edit(message)
else:
    pr.create_issue_comment(message)
