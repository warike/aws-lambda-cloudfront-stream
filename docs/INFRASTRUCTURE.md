# Infrastructure

The infrastructure is managed using Terraform and deployed to AWS.

## Configuration

The Terraform configuration is located in the `infra` directory.

### Key Files

- **Core**:
    - `provider.tf`: Configures the AWS provider.
    - `variables.tf`: Defines input variables.
    - `terraform.tfvars`: Sets values for variables (gitignored).
    - `main.tf`: Main entry point.

- **Resources**:
    - `lambda-chat.tf`: Defines the Chat Lambda function with `RESPONSE_STREAM` invoke mode.
    - `lambda-chat.iam.tf`: IAM roles and policies for the Lambda.
    - `lambda-chat.cloudwatch.tf`: CloudWatch Log Group for the Lambda.
    - `ecr.tf`: Defines the Elastic Container Registry (ECR) repository.
    - `cloudfront.tf`: Configures the CloudFront distribution.
    - `acm.tf`: Manages the ACM Certificate for the custom domain.

- **Functions**:
    - `functions/auth.js`: CloudFront Function for request handling (Domain Restriction).

### Resource Details

#### CloudFront & ACM
- **Distribution**: Serves the application and routes requests to the Lambda function URL.
- **Custom Domain**: Configured via ACM (e.g., `app.example.com`).
- **Restriction**: A CloudFront Function (`functions/auth.js`) ensures access is restricted to the specific host header.

#### Lambda Function
- **Name**: `chat-infra` (or similar, defined in `lambda-chat.tf`).
- **Type**: Docker Image.
- **Streaming**: Enabled via `invoke_mode = "RESPONSE_STREAM"`.

#### ECR Repository
- **Name**: `<ECR_REPO_NAME>` (Derived from `project_name` variable).
- **Region**: `us-east-1` (Note: ECR might be in a different region than other resources depending on setup, check `push_chat_image.sh`).

## Deployment

### Prerequisites
- AWS CLI configured with appropriate profile.
- Terraform installed.
- Docker installed (for building Lambda images).

### Workflow

### Workflow

The entire deployment process is automated via a `Makefile`.

1.  **Deploy Infrastructure**:
    This command compiles the server, builds/pushes the Docker image (with auto-versioning), applies Terraform changes, and runs integration tests.
    ```bash
    make deploy
    ```

## Scripts

- `Makefile`: Orchestrates the entire deployment workflow (build, push, apply, test).
- `infra/push_chat_image.sh`: Helper script used by the Makefile to build and push the Docker image.
- `infra/test_stream.sh`: Helper script used by `make test` to verify the Lambda streaming endpoint.
