##@ General

.PHONY: help
help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Dev
.PHONY:
start-services: stop-services ## Start the services locally
	docker compose up -d db

.PHONY:
stop-services: ## Stop the services running locally
	docker compose down --remove-orphans -v

.PHONY: test
test: ## Run the unit tests
	uv run pytest --cov=src --cov-context=test --cov-branch --cov-report=xml

##@ Linting
.PHONY: ruff
ruff: ## Run ruff linter
	uv run ruff check src tests

.PHONY: black
black: ## Python code formatter
	uv run black --check src tests

.PHONY: format
format: black ## Check formatting

.PHONY: type-check
type-check: ## Runs the type checker (mypy) against the app code
	uv run mypy src tests

.PHONY: lint
lint: ruff format type-check  ## Run linting checks

.PHONY: format-fix
format-fix: ## Run the auto-formatter
	uv run black src tests

.PHONY: lint-fix
lint-fix: format-fix ## Run the linter and fix issues
	uv run ruff check src tests --fix

.PHONY: check
check: lint test ## Run the linter and the unit tests

