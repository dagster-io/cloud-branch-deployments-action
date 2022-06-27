from github import Github
import os

"""
Fetches a user's avatar from the Github API based on email or username
"""


def main():
    # Fetch various pieces of info from the environment
    g = Github(os.getenv("GITHUB_TOKEN"))
    email = os.getenv("EMAIL")
    name = os.getenv("NAME")

    query = f"{email} OR {name}"
    res = g.search_users(query=query)
    if res.totalCount > 0:
        print(res[0].avatar_url)
    else:
        print("")


if __name__ == "__main__":
    main()
