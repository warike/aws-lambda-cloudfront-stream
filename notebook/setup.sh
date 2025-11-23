#!/bin/bash
set -e

echo "🚀 Starting Notebook Environment Setup..."

# 1. Check for pyenv and uv
if ! command -v pyenv &> /dev/null; then
    echo "❌ pyenv not found. Please install pyenv."
    exit 1
fi

if ! command -v uv &> /dev/null; then
    echo "❌ uv not found. Please install uv."
    exit 1
fi

# 2. Set Python Version
PYTHON_VERSION="3.11.6"
echo "📦 Setting local Python version to $PYTHON_VERSION..."
pyenv install $PYTHON_VERSION -s
pyenv local $PYTHON_VERSION

# 3. Create Virtual Environment with uv
if [ -d ".venv" ]; then
    echo "✅ Virtual environment already exists. Skipping creation."
else
    echo "🛠️  Creating virtual environment..."
    uv venv .venv
fi

# 4. Activate Virtual Environment
source .venv/bin/activate

# 5. Install Dependencies
echo "⬇️  Installing dependencies..."
uv pip install boto3 python-dotenv ipykernel jupyter numpy

# 6. Register Jupyter Kernel
echo "🔗 Registering Jupyter kernel 'aws-infra-test'..."
python -m ipykernel install --user --name=aws-infra-test --display-name "Python (AWS Infra Test)"

echo "✅ Setup Complete!"
echo "👉 Now open 'infrastructure_test.ipynb' and select the 'Python (AWS Infra Test)' kernel."
