.PHONY: deploy setup clean compile-server push-image terraform-apply destroy

# Extract current version from terraform file (e.g., chat-v1)
CURRENT_VERSION := $(shell grep -o 'chat-v[0-9]*' infra/lambda-chat.tf | head -n 1)
# Extract the number part (e.g., 1)
VERSION_NUM := $(shell echo $(CURRENT_VERSION) | sed 's/chat-v//')
# Increment the number
NEXT_VERSION_NUM := $(shell echo $$(($(VERSION_NUM) + 1)))
# Form the new version string (e.g., chat-v2)
NEXT_VERSION := chat-v$(NEXT_VERSION_NUM)

# Setup vector store infrastructure
setup:
	@echo "Setting up S3 Vector Store..."
	./infra/setup_vector_store.sh

# Deploy full stack (includes vector store setup)
deploy: setup compile-server push-image terraform-apply test

# Clean up vector store infrastructure
clean:
	@echo "Cleaning up S3 Vector Store..."
	./infra/cleanup_vector_store.sh

# Destroy all infrastructure (Terraform + Vector Store)
destroy: clean
	@echo "Destroying Terraform infrastructure..."
	cd infra && terraform destroy -auto-approve

compile-server:
	@echo "Compiling server app..."
	cd apps/server && pnpm install && pnpm run build

push-image:
	@echo "Current version: $(CURRENT_VERSION)"
	@echo "Next version: $(NEXT_VERSION)"
	@echo "Building and pushing Docker image..."
	./infra/push_chat_image.sh $(NEXT_VERSION)
	@echo "Updating Terraform configuration..."
	# Update the version in the terraform file
	sed -i '' 's/$(CURRENT_VERSION)/$(NEXT_VERSION)/g' infra/lambda-chat.tf

terraform-apply:
	@echo "Applying Terraform changes..."
	cd infra && terraform apply

test:
	@echo "Running integration tests..."
	./infra/test_stream.sh
