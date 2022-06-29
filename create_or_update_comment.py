from github import Github
import os

print(os.environ)

g = Github(os.getenv("GITHUB_TOKEN"))
pr_id = int(os.getenv("PR_NUMBER"))
repo_id = os.getenv("GITHUB_REPOSITORY")
action = os.getenv("ACTION")

current_user = g.get_user()

repo = g.get_repo(repo_id)
pr = repo.get_pull(pr_id)

comments = pr.get_issue_comments()
comment_to_update = None
for comment in comments:
    if comment.user.login == current_user.login:
        comment_to_update = comment
        break

message = f"{action} :sunglasses:"

if comment_to_update:
    comment_to_update.edit(message)
else:
    pr.create_issue_comment(message)
