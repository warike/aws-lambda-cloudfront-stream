# Notebook Environment Setup

This directory contains Jupyter notebooks for testing the AWS infrastructure.

## Environment Setup Analysis: `pyenv` + `uv`

You requested to use `pyenv` and `uv`. Here is an analysis of this choice:

### **Pros (Why it's a good choice)**
1.  **Speed**: `uv` is an extremely fast Python package installer and resolver, written in Rust. It is significantly faster than `pip` and `poetry`.
2.  **Isolation**: `pyenv` ensures that the project uses a specific Python version, independent of the system's Python. This prevents version conflicts.
3.  **Modern Workflow**: This combination represents a modern, efficient Python development workflow.

### **Cons/Considerations**
1.  **Tool Availability**: Requires both tools to be installed (which we verified you have).
2.  **Kernel Registration**: For Jupyter to "see" the virtual environment, it must be registered as a kernel. The `setup.sh` script handles this.

## Getting Started

1.  **Configure Environment Variables**:
    Copy `.env.example` to `.env` and fill in your AWS details.
    ```bash
    cp .env.example .env
    ```

2.  **Run Setup Script**:
    This script will use `pyenv` to set the local Python version, create a virtual environment with `uv`, install dependencies, and register the Jupyter kernel.
    ```bash
    chmod +x setup.sh
    ./setup.sh
    ```

3.  **Run the Notebook**:
    Open `infrastructure_test.ipynb` in VS Code or Jupyter Lab. Ensure the kernel selected is `aws-infra-test`.

4.  **Run Vector Search Test**:
    Open `s3_vector_search.ipynb` to test vector generation and search capabilities.
