# Plan: Notebook Environment Setup

**Status**: ✅ COMPLETED  
**Date**: 2025-11-22

## 1. Task Description
Establish a robust, isolated Python environment for testing AWS infrastructure and AI/ML services (Bedrock, S3). The environment must support rapid iteration and dependency management.

### Requirements
- Use `pyenv` for Python version management.
- Use `uv` for fast package resolution and virtual environment management.
- Support loading environment variables from `.env`.
- Include AWS SDK (`boto3`) and Jupyter support.

## 2. Implementation Plan

### Architecture
- **Location**: `/notebook`
- **Tooling**: `pyenv` (Python 3.11.6), `uv`, `ipykernel`.

### Files Created
- `notebook/setup.sh`: Automates the creation of the environment and kernel registration.
- `notebook/.env.example`: Template for required environment variables.
- `notebook/infrastructure_test.ipynb`: Interactive notebook for validating connections.

### Setup Steps
1.  Check for `pyenv` and `uv` installation.
2.  Install Python 3.11.6.
3.  Create virtual environment `.venv`.
4.  Install `boto3`, `python-dotenv`, `jupyter`.
5.  Register custom Jupyter kernel `aws-infra-test`.

## 3. Verification Plan

### Automated Checks
- [x] `setup.sh` runs without errors.
- [x] Virtual environment `.venv` is created.
- [x] Jupyter kernel `aws-infra-test` is registered.

### Manual Verification
1.  **Configuration**: Copy `.env.example` to `.env` and populate with valid AWS credentials.
2.  **S3 Connectivity**: Run "Test 1" in `infrastructure_test.ipynb`.
    - *Expected Result*: Lists objects in the bucket or confirms bucket is empty.
3.  **Bedrock Invocation**: Run "Test 2" in `infrastructure_test.ipynb`.
    - *Expected Result*: Returns a text response from the Llama 3 model.

### Credits
Created by [Warike technologies](https://warike.tech)
