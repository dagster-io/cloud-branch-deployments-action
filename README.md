# Dagster Cloud Branch Deployments GitHub Action

[GitHub Actions](https://docs.github.com/en/actions) to deploy code locations to Dagster Cloud and to manage Branch Deployments.

## Quickstart

Want to get started right away, or look at a functional example for reference? We provide a [quickstart template repo](https://github.com/dagster-io/dagster-cloud-branch-deployments-quickstart) which you can use to get CI & branch deployments for your Cloud instance up and running quickly.

## Overview
### `deploy` Action

The `deploy` action can be used to deploy code to Dagster Cloud as part of a static Deployment (e.g. `prod`) or to dynamically-created Branch Deployments.

The `deploy` action assumes that a Docker image containing Dagster code has already been built and pushed to an image registry accessible by your Dagster Cloud agent.

#### Updating Code on Static Deployment

To update code for a single, fixed deployment (e.g. `prod`), you must
pass the deployment to the `deploy` action directly.

```yaml
- name: Deploy to Production
  uses: ./deploy
  id: deploy
  with:
    organization_id: pied-piper
    deployment: prod
    location: ${{ toJson(matrix.location) }}
    image_tag: ${{ github.sha }}
  env:
    DAGSTER_CLOUD_API_TOKEN: ${{ secrets.DAGSTER_CLOUD_API_TOKEN }}
```

#### Updating Branch Deployment

To create or update a branch deployment for a given PR, you should
instead pass information about the PR itself.

```yaml
- name: Deploy to Branch Deployment
  uses: ./deploy
  id: deploy
  with:
    organization_id: pied-piper
    pr: "${{ github.event.number }}"
    pr_status: "${{ github.event.pull_request.merged && 'merged' || github.event.pull_request.state }}"
    location: ${{ toJson(matrix.location) }}
    image_tag: ${{ github.sha }}
  env:
    DAGSTER_CLOUD_API_TOKEN: ${{ secrets.DAGSTER_CLOUD_API_TOKEN }}
```

### `notify` Action

The optional `notify` action updates a status message on a Pull Request with the build and deploy status of your Dagster Cloud code locations.

In our [sample workflow](./.github/workflows/branch_deployments.yml), it is invoked at the start of the build process to mark the build as `pending` and after the build marks it as `complete` or `failed`.

