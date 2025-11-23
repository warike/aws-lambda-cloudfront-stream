# Warike technologies -  AWS Lambda CloudFront Stream Project

This project demonstrates a generative AI use case using AWS Lambda, CloudFront, and streaming responses. It leverages a serverless architecture to provide real-time chat capabilities.

## Project Structure

- `apps/server`: A Node.js/TypeScript server application containerized for AWS Lambda.
- `infra`: Terraform configuration and scripts for deploying the AWS infrastructure (CloudFront, Lambda, ECR, ACM).
- `notebook`: Jupyter notebooks for experimentation and testing.
- `docs`: Documentation for the project.

## Documentation

- [Infrastructure](./INFRASTRUCTURE.md): Details on the AWS resources and Terraform configuration.
- [Lambda Streaming](./LAMBDA_STREAMING.md): Specifics on the streaming chat Lambda and its deployment.
- [Components](./COMPONENTS.md): Details on the application components (Server, CloudFront Functions).

## Project Plans & Tasks

- [01. Notebook Environment Setup](./docs/plans/01_NOTEBOOK_ENVIRONMENT.md)
- [02. Infrastructure Deployment](./docs/plans/02_INFRASTRUCTURE_DEPLOYMENT.md)
- [03. Server Application Development](./docs/plans/03_SERVER_APP_DEVELOPMENT.md)

## Quick Links

- **Infrastructure Scripts**:
    - Full Deployment: `make deploy`
    - Test Streaming: `make test`
- **CloudFront Function**: `infra/functions/auth.js`


## Credits
Created by [Warike technologies](https://warike.tech)