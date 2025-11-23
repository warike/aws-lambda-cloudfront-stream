"""
Environment Variable Cache Clearing Helper

Add this code cell to your Jupyter notebooks to manually clear and reload environment variables.
This is useful when you've updated your .env file and want to reload it without restarting the kernel.
"""

# Option 1: Clear specific env vars before reloading
import os
from dotenv import load_dotenv

# List of env vars to clear (add your variables here)
env_vars_to_clear = [
    'AWS_REGION',
    'AWS_PROFILE',
    'S3_BUCKET_NAME_SOURCE',
    'S3_BUCKET_NAME_DESTINATION',
    'BEDROCK_MODEL_ID',
    'BEDROCK_EMBEDDING_MODEL_ID',
    'S3_VECTOR_BUCKET_NAME',
    'S3_VECTOR_INDEX_NAME'
]

# Clear the variables
for var in env_vars_to_clear:
    if var in os.environ:
        del os.environ[var]
        print(f"🗑️  Cleared: {var}")

# Force reload from .env
load_dotenv(override=True)
print("\n✅ Environment variables reloaded from .env file")

# Verify
print("\n📋 Current values:")
for var in env_vars_to_clear:
    value = os.getenv(var, "NOT SET")
    print(f"   {var}: {value}")
