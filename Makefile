create-k3d-cluster: ## Deploy a k3d cluster
	@./scripts/create-k3d-cluster.sh

prepare-ci-env: ## Prepare the CI env before installing Epinio
	@./scripts/prepare-ci-env.sh

upgrade-test: ## Test if we can upgrade epinio helm chart
	@./scripts/upgrade-test.sh

help: ## Show this Makefile's help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
