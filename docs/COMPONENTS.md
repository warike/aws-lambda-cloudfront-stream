# Application Components

This document describes the software components of the project.

## Server Application (`apps/server`)

The core logic resides in a Node.js/TypeScript application designed to run within a Docker container on AWS Lambda.

### Key Features
- **Streaming Support**: Implements response streaming to support real-time AI generation feedback.
- **Containerized**: Packaged as a Docker image for consistent deployment.
- **Tech Stack**:
    - TypeScript
    - Node.js
    - AWS Lambda Node.js Runtime (Standard)

### Structure
- `src/`: Source code.
- `Dockerfile`: Instructions for building the Lambda-compatible container image.

## CloudFront Functions (`infra/functions`)

Lightweight JavaScript functions that run at the CloudFront edge locations to manipulate requests and responses.

### `auth.js`
- **Purpose**: Domain Restriction / Simple Authorization.
- **Logic**:
    - Inspects the `Host` header of the incoming request.
    - Compares it against an allowed domain (e.g., `app.example.com`).
    - If the host does not match, it returns a `403 Forbidden` response.
    - If it matches, the request is allowed to proceed to the origin (Lambda).
- **Association**: Typically associated with the `viewer-request` event in the CloudFront distribution.
