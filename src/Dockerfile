
# Container image that runs your code
FROM 764506304434.dkr.ecr.us-west-2.amazonaws.com/dagster-cloud-cli-dev:0.9
# RUN pip install dagster-cloud-cli

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY create_or_update_comment.py /create_or_update_comment.py
COPY expand_json_env.py /expand_json_env.py


COPY notify.sh /notify.sh
COPY deploy.sh /deploy.sh
