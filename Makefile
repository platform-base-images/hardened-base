REGISTRY   ?= ghcr.io/platform-base-images
VERSION    ?= 1.0.0
PLATFORM   ?= linux/amd64,linux/arm64
BUILD_DATE ?= $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")
GIT_REV    ?= $(shell git rev-parse --short HEAD 2>/dev/null || echo "unknown")

BUILD_ARGS = \
  --build-arg BUILD_DATE="$(BUILD_DATE)" \
  --build-arg GIT_REVISION="$(GIT_REV)"

.PHONY: build build-distroless build-all scan test lint sign sbom all help

help:
	@echo "Usage: make <target> IMAGE=<image-name>"
	@echo ""
	@echo "Targets:"
	@echo "  build            Build the standard variant of IMAGE"
	@echo "  build-distroless Build the distroless variant of IMAGE (if it exists)"
	@echo "  build-all        Build all images"
	@echo "  scan             Run Trivy CVE scan against the built standard image"
	@echo "  test             Run container-structure-test + goss against the standard image"
	@echo "  lint             Run Dockle (CIS) + OPA/Conftest policy checks"
	@echo "  sign             Sign the image with Cosign (requires COSIGN_KEY or keyless auth)"
	@echo "  sbom             Generate SBOM with Syft and attach as OCI attestation"
	@echo "  all              build + scan + test + lint"

build:
	@test -n "$(IMAGE)" || (echo "ERROR: IMAGE is required. Example: make build IMAGE=nodejs-base" && exit 1)
	docker build $(BUILD_ARGS) \
	  -t $(REGISTRY)/$(IMAGE):$(VERSION) \
	  images/$(IMAGE)/

build-distroless:
	@test -n "$(IMAGE)" || (echo "ERROR: IMAGE is required." && exit 1)
	@test -f images/$(IMAGE)/Dockerfile.distroless || (echo "No Dockerfile.distroless for $(IMAGE)" && exit 1)
	docker build $(BUILD_ARGS) \
	  -f images/$(IMAGE)/Dockerfile.distroless \
	  -t $(REGISTRY)/$(IMAGE):$(VERSION)-distroless \
	  images/$(IMAGE)/

build-all:
	@for img in wolfi-base nodejs-base python-base openjdk-base nginx-base go-base; do \
	  echo "==> Building $$img"; \
	  make build IMAGE=$$img; \
	  if [ -f images/$$img/Dockerfile.distroless ]; then make build-distroless IMAGE=$$img; fi; \
	done

scan:
	@test -n "$(IMAGE)" || (echo "ERROR: IMAGE is required." && exit 1)
	trivy image \
	  --exit-code 1 \
	  --severity CRITICAL,HIGH,MEDIUM \
	  --ignore-unfixed \
	  $(REGISTRY)/$(IMAGE):$(VERSION)

test:
	@test -n "$(IMAGE)" || (echo "ERROR: IMAGE is required." && exit 1)
	container-structure-test test \
	  --image $(REGISTRY)/$(IMAGE):$(VERSION) \
	  --config images/$(IMAGE)/tests/structure-test.yaml
	dgoss run $(REGISTRY)/$(IMAGE):$(VERSION)

lint:
	@test -n "$(IMAGE)" || (echo "ERROR: IMAGE is required." && exit 1)
	dockle --exit-code 1 --exit-level warn $(REGISTRY)/$(IMAGE):$(VERSION)
	conftest test images/$(IMAGE)/Dockerfile --policy policies/dockerfile.rego

sign:
	@test -n "$(IMAGE)" || (echo "ERROR: IMAGE is required." && exit 1)
	cosign sign \
	  --yes \
	  $(REGISTRY)/$(IMAGE):$(VERSION)

sbom:
	@test -n "$(IMAGE)" || (echo "ERROR: IMAGE is required." && exit 1)
	syft $(REGISTRY)/$(IMAGE):$(VERSION) \
	  -o spdx-json \
	  --file images/$(IMAGE)/sbom.spdx.json
	cosign attest \
	  --yes \
	  --predicate images/$(IMAGE)/sbom.spdx.json \
	  --type spdx \
	  $(REGISTRY)/$(IMAGE):$(VERSION)

all: build scan test lint
