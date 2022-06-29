
# Container image that runs your code
FROM 764506304434.dk
RUN apk add --no-cache make automake gcc g++ git 
# RUN pip install dagster-cloud-cli

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]