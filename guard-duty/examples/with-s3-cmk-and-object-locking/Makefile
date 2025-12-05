.ONESHELL:
.SHELL := /bin/bash
.PHONY: all plan apply destroy

# #########################################
# Shell swag
# #########################################
RED = \033[1;91m
GREEN = \033[1;32m
WHITE = \033[1;38;5;231m
RESET = \n\033[0m

# #########################################
# Commands args
# #########################################
plan_file = terraform.tfplan
color_flag ?=
init_flags ?= -get=false -get-plugins=false

all: init plan apply

init:
	@echo -e "$(WHITE)==> Initializing - $(GREEN)terraform init$(RESET)"
	terraform init -lock=true -input=false

update:
	@echo -e "$(WHITE)==> Updating modules - $(GREEN)terraform get$(RESET)"
	terraform get --update

validate:
	@echo -e "$(WHITE)==> Validate terraform code - $(GREEN)terraform validate$(RESET)"
	terraform validate $(var_flags)

plan:
	@echo -e "$(WHITE)==> Planing changes - $(GREEN)terraform plan$(RESET)"
	terraform plan -out $(plan_file) $(color_flag) $(var_flags) $(ARGS)

apply:
	@echo -e "$(WHITE)==> Aplying changes - $(GREEN)terraform apply$(RESET)"
	terraform apply -parallelism=10 $(plan_file)

destroy:
	@echo -e "$(WHITE)==> Planing to destroy - $(GREEN)terraform plan -destroy$(RESET)"
	terraform plan -destroy -out $(plan_file) $(color_flag) $(var_flags) $(ARGS)

refresh:
	@echo -e "$(WHITE)==> Refreshing local state - $(GREEN)terraform refresh(RESET)"
	terraform refresh $(var_flags)

graph:
	@echo -e "$(WHITE)==> Create terraform resources graph - $(GREEN)terraform graph$(RESET)"
	terraform graph -draw-cycles | dot -Tpng > graph.png

import:
	@echo -e "$(WHITE)==> Import terraform resources - $(GREEN)terraform import$(RESET)"
	terraform import $(var_flags) ${ARGS}

output:
	@echo -e "$(WHITE)==> Saving output variables for environment - $(GREEN)terraform output(RESET)"
	terraform output -json > terraform-output.json
