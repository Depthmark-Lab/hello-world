.PHONY: build test test-race lint coverage clean docker ci act act-lint act-test act-build

# Build all packages
build:
	go build ./...

# Run all tests
test:
	go test ./...

# Run tests with race detector
test-race:
	go test -race ./...

# Run tests with coverage
coverage:
	go test -coverprofile=coverage.out ./...
	go tool cover -func=coverage.out
	@echo "---"
	@echo "HTML report: go tool cover -html=coverage.out -o coverage.html"

# Run linter
lint:
	golangci-lint run ./...

# Build production binary
bin/hello-world:
	CGO_ENABLED=0 go build -ldflags="-s -w" -o bin/hello-world ./cmd/hello-world

# Build Docker image
docker:
	docker build -t hello-world:local .

# Clean build artifacts
clean:
	rm -rf bin/ coverage.out coverage.html

# Run all checks (CI)
ci: lint test-race build bin/hello-world

# Run all CI jobs locally with act
act:
	act pull_request --workflows .github/workflows/ci.yml

# Run individual CI jobs locally with act
act-lint:
	act pull_request --workflows .github/workflows/ci.yml --job lint

act-test:
	act pull_request --workflows .github/workflows/ci.yml --job test

act-build:
	act pull_request --workflows .github/workflows/ci.yml --job build
