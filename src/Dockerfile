
FROM python:3.8.12-slim

# Install deps
RUN apt update && apt install git -y
RUN pip install dagster \
                dagster-cloud-cli \ 
                PyGithub

# Copy over various Python utilities
COPY create_or_update_comment.py /create_or_update_comment.py
COPY expand_json_env.py /expand_json_env.py
COPY fetch_github_avatar.py /fetch_github_avatar.py


COPY notify.sh /notify.sh
COPY deploy.sh /deploy.sh
COPY run.sh /run.sh
