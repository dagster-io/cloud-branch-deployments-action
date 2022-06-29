
# Container image that runs your code
FROM 764506304434.dkr.ecr.us-west-2.amazonaws.com/dagster-cloud-cli-dev:0.1

# RUN pip install dagster-cloud-cli

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]