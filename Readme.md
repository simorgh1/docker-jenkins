# Jenkins Docker for hosting in AWS

Hosting Jenkins in AWS for continouse deployment projects hosted in GitHub.

## Content

- Dockerfile
- Docker-compose file
- CloudFormation Stack file

## Dockerfile

It uses the official jenkins lts image as base and adds the following components:

- docker ce: The default value of the docker ce version could be overriden by the docker argument DOCKER_ENGINE.
- docker compose: The default value of the docker ce version could be overriden by the docker argument DOCKER_COMPOSE.
- make is used for invoking the steps required during the continouse deployment such as test, build, release, clean etc.
- ansible is used for application startup probing.
- boto is used to access aws.
- jenkins predefined plugins is installed as last step.

## docker-compose file

In order to configure jenkins service, before starting, please create the required external volume for jenkins home.

## CloudFormation Stack file

Configures the jenkins stack hosted in AWS ECS cluster
