
# Define variables
ENV ?= dev
BACKEND ?= non-prod-backend
TERRAFORM_VERSION_FILE := terraform_version.txt

# Default target
all: plan

# Check Terraform version
check:
	@echo "Checking Terraform version..."
	terraform --version > $(TERRAFORM_VERSION_FILE)

# Terraform init
init:
	@echo "Initializing Terraform..."
	terraform init -backend-config="hcl/$(BACKEND).hcl"

# Terraform plan
plan: check init
	@echo 'Switching to the [$(ENV)] environment ...'
	terraform workspace select -or-create=true $(ENV)

	terraform plan \
	 -var-file="env_vars/$(ENV).tfvars"

# Terraform apply
#@rm plans/$(ENV).plan => should be used below terraform apply
apply: check init
	@echo 'Switching to the [$(ENV)] environment ...'
	terraform workspace select -or-create=true $(ENV)

	@echo "Applying Terraform plan for environment: $(ENV)"
	terraform apply -var-file="env_vars/$(ENV).tfvars" -auto-approve
	
# Terraform destroy
destroy:
	@echo "Destroying Terraform plan for environment: $(ENV)"
	terraform destroy -var-file="env_vars/$(ENV).tfvars" -auto-approve

# Clean up generated files
clean:
	@echo "Cleaning up..."
	-del /F /Q $(TERRAFORM_VERSION_FILE)

# Help
help:
	@echo "Makefile targets:"
	@echo "  make all    -> Default target, runs 'plan'"
	@echo "  make check  -> Check Terraform version"
	@echo "  make init   -> Initialize Terraform"
	@echo "  make plan   -> Run Terraform plan"
	@echo "  make apply  -> Apply Terraform plan"
	@echo "  make destroy -> Destroy Terraform plan"
	@echo "  make clean  -> Clean up generated files"
	@echo "  make help   -> Show this help message"

.PHONY: all check init plan apply clean help
