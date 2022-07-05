
FROM 764506304434.dkr.ecr.us-west-2.amazonaws.com/dagster-cloud-cli-dev:0.9
# RUN pip install dagster-cloud-cli

# Copy over various Python utilities
COPY create_or_update_comment.py /create_or_update_comment.py
COPY expand_json_env.py /expand_json_env.py
COPY fetch_github_avatar.py /fetch_github_avatar.py


COPY notify.sh /notify.sh
COPY deploy.sh /deploy.sh
