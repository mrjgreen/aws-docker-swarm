SHELL += -eu

BLUE	:= \033[0;34m
GREEN	:= \033[0;32m
RED     := \033[0;31m
NC      := \033[0m

DOCKER_REGISTRY := "<YOUR DOCKER HUB USER or DOCKER REGISTRY URI>"

all:
	@echo "${BLUE}run 'make plan' to initialise terraform and plan your infrastructure${NC}"

clean: destroy
	@rm -fr .terraform
	@rm -f .terraform-output-cache
	@rm -f .terraform.plan

build-helpers:
	docker build -t ${DOCKER_REGISTRY}/aws-swarm-init docker/aws-swarm-init
	docker push ${DOCKER_REGISTRY}/aws-swarm-init

include makefiles/*.mk

.PHONY: build-helpers
