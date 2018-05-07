#!make
################# Variables #######################
SHELL           ?= /usr/local/bin/bash
DOCKER		    ?= docker
DOCKER_COMPOSE  ?= docker-compose -p fp-app 
# DOCKER_COMPOSE_APP2  ?= docker-compose -p fp-app2 
DOCKER_COMPOSE_PHP  ?= docker-compose -p fp-php
SUDO_CHMOD      ?= sudo chmod -R 777
###################################################

##### Makefile related #####
.PHONY: docker-info docker-up help docker-kill-all up stop clean

default: help

all: up 	##@fp-app Up the system

docker-info: ##@docker Name, hostname and container id from containers started with docker-compose
	@$(eval FORMAT={{ .Name }} {{ .Config.Hostname }} {{ if not .NetworkSettings.Networks.front_net }} {{ else }}{{ index .NetworkSettings.Networks.front_net.IPAddress }}{{end}} {{ if not .NetworkSettings.Networks.back_net }} {{else}}{{ index .NetworkSettings.Networks.back_net.IPAddress }}{{end}})
	@printf "\n%-36s %-20s %-20s %-20s\n" "Name" "ContainerID" "IP Front Net" "IP Back Net"
	@echo "-------------------------------------------------------------------------------------------"
	@$(DOCKER) inspect --format "$(FORMAT)" $(shell $(DOCKER) ps -q) | awk '{ printf "%-36s %-20s %-20s %-20s\n", $$1, $$2, $$3, $$4 }'

docker-up: # ##@docker Start application
	$(DOCKER_COMPOSE) up -d --build --remove-orphans
	$(DOCKER_COMPOSE) ps

docker-kill-all: ##@docker Caution: stops and removes all Docker containers
	$(DOCKER) stop $(shell $(DOCKER) ps -a -q)
	$(DOCKER) rm $(shell $(DOCKER) ps -a -q)

docker-clean: ##@docker Clean docker automation
	$(DOCKER_COMPOSE) kill
	$(DOCKER_COMPOSE) rm -fv
	$(DOCKER_COMPOSE) down
	$(DOCKER_COMPOSE_PHP) kill
	$(DOCKER_COMPOSE_PHP) rm -fv
	$(DOCKER_COMPOSE_PHP) down

clean-dbs: ##@clean Clean docker automation
	$(SUDO_CHMOD) docker/data/db
	@rm -rf docker/data/db/*
	@rm -rf docker/data/redis/*

##### Main Targets #####

up: docker-up docker-info	##@fp-app Build and start containers with docker-compose and display some status info

stop:	##@fp-app Stop all running containers, started with docker-compose
	$(DOCKER_COMPOSE) stop
	$(DOCKER_COMPOSE_PHP) stop

clean: docker-clean clean-dbs ##@fp-app Remove automation containers and clean dbs


# Help based on https://gist.github.com/prwhite/8168133 thanks to @nowox and @prwhite
# And add help text after each target name starting with '\#\#'
# A category can be added with @category

HELP_FUN = \
		%help; \
		while(<>) { push @{$$help{$$2 // 'options'}}, [$$1, $$3] if /^([\w-]+)\s*:.*\#\#(?:@([\w-]+))?\s(.*)$$/ }; \
		print "\nusage: make [target ...]\n\n"; \
	for (keys %help) { \
		print "$$_:\n"; \
		for (@{$$help{$$_}}) { \
			$$sep = "." x (25 - length $$_->[0]); \
			print "  $$_->[0]$$sep$$_->[1]\n"; \
		} \
		print "\n"; }

help: ##@system Show this help
	#
	# General targets
	#
	@perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)
