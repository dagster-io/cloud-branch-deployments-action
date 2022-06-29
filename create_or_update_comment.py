from github import Github
import os

print(os.environ)

g = Github(os.getenv("GITHUB_TOKEN"))
pr_id = int(os.getenv("INPUT_PR"))
repo_id = os.getenv("GITHUB_REPOSITORY")
action = os.getenv("INPUT_ACTION")


repo = g.get_repo(repo_id)
pr = repo.get_pull(pr_id)

comments = pr.get_issue_comments()
comment_to_update = None
for comment in comments:
    if comment.user.login == "github-actions[bot]" and "Dagster Cloud" in comment.body:
        comment_to_update = comment
        break

message = f"Your pull request is automatically being deployed to Dagster Cloud. {action}"

if comment_to_update:
    comment_to_update.edit(message)
else:
    pr.create_issue_comment(message)
