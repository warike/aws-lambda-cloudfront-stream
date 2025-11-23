# Plan: Infrastructure Deployment

**Status**: ✅ COMPLETED  
**Date**: 2025-11-23

## 1. Task Description
Deploy the core AWS infrastructure required to support the Generative AI application. This includes storage for vector embeddings (if needed) or documents, and the compute layer for the AI logic.

### Requirements
- Use Terraform for Infrastructure as Code (IaC).
- Deploy to `us-west-2` (or configured region).
- Resources:
    - **S3 Bucket**: For storing documents/assets.
    - **Lambda Function**: For handling chat requests and streaming responses.
    - **CloudFront**: For content delivery and lightweight validation (CloudFront Functions).

## 2. Implementation Plan

### Architecture
- **Location**: `/infra`
- **State Management**: Local state (for now).

### Files
- `infra/provider.tf`: AWS Provider configuration.
- `infra/variables.tf`: Project variables.
- `infra/main.tf`: Resource definitions.
- `infra/lambda-chat.tf`: Chat Lambda configuration.
- `infra/cloudfront.tf`: CloudFront distribution.
- `infra/ecr.tf`: ECR Repository.

### Steps
1.  **Define Resources**: Update `main.tf` to define the S3 bucket and basic Lambda execution role.
2.  **Initialize**: Run `terraform init`.
3.  **Plan**: Run `terraform plan` to preview changes.
4.  **Apply**: Run `make deploy` to provision resources.

## 3. Verification Plan

### Infrastructure Validation
- [x] `terraform validate` passes.
- [x] `make deploy` completes successfully.

### Functional Testing (via Notebook)
- [x] **S3 Access**: Use `infrastructure_test.ipynb` to verify the created bucket is accessible and writable.
- [ ] **Create Embeddings**: Verify that embeddings can be generated and stored (Pending).
- [x] **Lambda Invocation**: Test invoking the Lambda function directly via AWS SDK.
