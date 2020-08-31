ROOT_PATH				= $(PWD)
EXAMPLES_DIR			= $(ROOT_PATH)/examples
TEST_DIR				= $(ROOT_PATH)/tests
FEATURES_DIR			= $(TEST_DIR)/features
UNIT_TEST_DIR			= $(TEST_DIR)/unit
PLAN_FILE				= plan.out

.DEFAULT_GOAL := help

generate-plan:
	@echo "Generating plan"
	cd $(EXAMPLES_DIR) && terraform init && terraform plan -out=$(EXAMPLES_DIR)/$(PLAN_FILE) --var-file=$(EXAMPLES_DIR)/terraform.tfvars

run-static-tests:
	@echo "Running static analysis"
	cd $(EXAMPLES_DIR) && terraform-compliance --planfile $(EXAMPLES_DIR)/$(PLAN_FILE) --features $(FEATURES_DIR)

run-unit-tests:
	@echo "Running unit tests"
	@cd $ $(UNIT_TEST_DIR) && go test

remove-plan-files:
	@rm $(EXAMPLES_DIR)/plan.*

clean: remove-plan-files ## Clean up directory

test:  generate-plan run-static-tests run-unit-tests clean ## Run unit tests

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'