# Lambda Streaming Setup

This document details the specific setup for the Chat Lambda function which supports streaming responses.

## Overview

The Chat Lambda allows for real-time token streaming, essential for Generative AI chat interfaces. It is implemented as a Docker container running a Node.js server.

## Configuration

### Lambda Function (`infra/lambda-chat.tf`)

- **Invoke Mode**: `RESPONSE_STREAM`
    - This is the critical setting that allows the Lambda to stream data back to the client before the execution is complete.
- **Runtime**: `FROM public.ecr.aws/lambda/nodejs:20` (defined in Dockerfile).
- **Architecture**: `linux/amd64`.

### Container Registry

- **Repository Name**: `<ECR_REPO_NAME>` (Derived from `project_name` variable)
- **Account ID**: `<AWS_ACCOUNT_ID>`
- **Region**: `us-east-1`
- **Image Tag**: `chat-v1`

## Build & Deploy Process

The deployment relies on a helper script to manage the Docker build and push process.

### Deployment via Makefile

The deployment process is orchestrated using a `Makefile` which handles versioning, building, pushing, and applying Terraform changes.

**Usage:**
```bash
make deploy
```

This command performs the following steps:
1.  **Compile**: Builds the server application (`apps/server`).
2.  **Push Image**: Increments the version, builds the Docker image, and pushes it to ECR.
3.  **Apply**: Runs `terraform apply` to update the infrastructure.
4.  **Test**: Runs the streaming integration test.

## Testing Streaming

To verify that the streaming is working correctly without a frontend, use the provided test script.

### Testing via Makefile

To verify that the streaming is working correctly, use the `make test` command.

**Usage:**
```bash
make test
```

**Expected Behavior:**
You should see the generated text response appearing in chunks as it is streamed from the AI model.

### Credits
Created by [Warike technologies](https://warike.tech)