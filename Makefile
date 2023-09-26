# To tag docker images
GIT_TAG ?= $(shell git log -1 --pretty=%h)
export GIT_TAG

# Theia IDES
THEIA_BASE_IDE := \
	theia-base-38 theia-base-39 theia-base-310 theia-base-311

THEIA_IDES := \
	theia-cpp theia-procdesign theia-admin theia-golang \
	theia-flask-39 theia-flask-310 \
	theia-mysql-39 theia-mysql-310 \
	theia-devops theia-jepst

WEBTOP_BASE_IDES := \
	webtop-base-310 webtop-base-39 webtop-base-38

WEBTOP_IDES := \
	webtop-jepst

help:
	@echo 'For convenience'
	@echo
	@echo 'Available make targets:'
	@grep PHONY: Makefile | cut -d: -f2 | sed '1d;s/^/make/'

.PHONY: context         # Grab kubectl and registry login from doctl
context:
	doctl kubernetes cluster kubeconfig save anubis2 --context anubis
	doctl registry login --context anubis

.PHONY: deploy          # Build, Push & Propigate all ides
deploy: build-base-ides build-ides push-base-ides push-ides prop-ides

.PHONY: build-base-ides # Build base ide images
build-base-ides:
	@echo 'building base images'
	docker compose build --parallel --pull $(THEIA_BASE_IDE)

.PHONY: build-ides      # Build all ide docker images
build-ides:
	@echo 'building ide image'
	docker compose build --parallel $(THEIA_IDES)

.PHONY: push-base-ides  # Push base ide images to registry.digitalocean.com
push-base-ides:
	docker compose push $(THEIA_BASE_IDE)

.PHONY: push-ides       # Push ide images to registry.digitalocean.com
push-ides:
	docker compose push $(THEIA_IDES)

.PHONY: pull-base-ides  # Pull base ide images to registry.digitalocean.com
pull-base-ides:
	docker compose pull $(THEIA_BASE_IDE)

.PHONY: pull-ides       # Pull ide images to registry.digitalocean.com
pull-ides:
	docker compose pull $(THEIA_IDES)

.PHONY: prop-ides       # Create theia-prop daemonset to propagate latest ide images
prop-ides:
	kubectl rollout restart ds anubis-theia-prop -n anubis

webtop:
	@echo 'building ide image'
	docker compose build --parallel $(WEBTOP_BASE_IDES)
	docker compose build --parallel $(WEBTOP_IDES)
	docker compose push $(WEBTOP_BASE_IDES) $(WEBTOP_IDES)
