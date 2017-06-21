.terraform:
	terraform init

# This allows us to query the json file rather than running `terraform output` each time which is slow
output-cache:
	terraform output --json > .terraform-output-cache

init: .terraform

get:
	terraform get

validate: init
	terraform validate
	@echo "${GREEN}✓ terraform validate - success${NC}"

plan: validate
	terraform plan -input=false -out=terraform.tfplan
	@echo "${GREEN}✓ terraform plan - success${NC}"
	@echo "${BLUE}run 'make apply' to create your infrastructure${NC}"

apply:
	@echo "${BLUE}terraform apply - commencing${NC}"
	terraform apply terraform.tfplan
	@rm -f terraform.tfplan
	@$(MAKE) output-cache
	@echo "${GREEN}✓ make $@ - success${NC}"

destroy:
	terraform destroy

show:
	terraform show

.PHONY: apply destroy init plan get show output-cache
