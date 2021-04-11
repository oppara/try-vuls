SHELL := /bin/bash
CONF = ./configs/config.toml

all: help

.PHONY: config
config: ## configtest
	docker-compose run --rm vuls configtest -config=$(CONF)

.PHONY: scan
scan: ## scan
	docker-compose run --rm vuls scan -config=$(CONF)

.PHONY: report
report: ## report
	docker-compose run --rm vuls report -lang ja -config=$(CONF)

.PHONY: tui
tui: ## tui
	docker-compose run --rm vuls tui -config=$(CONF)

.PHONY: gui
gui: ## gui
	open http://localhost:8080/

.PHONY: init
init: ## fetch all data
	@make init-cve
	@make oval
	@make gost
	@make expliotdb
	@make msfdb

.PHONY: update
update: ## update all data
	@make cve
	@make oval
	@make gost
	@make expliotdb
	@make msfdb

.PHONY: cve
cve: ## update nvd & jvn data
	docker-compose run --rm cve fetchnvd -latest
	docker-compose run --rm cve fetchjvn -latest

.PHONY: init-cve
init-cve: ## fetch nvd & jvn data
	$(CURDIR)/init-cve.sh

.PHONY: oval
oval: ## fetch oval
	docker-compose run --rm oval fetch-amazon
	docker-compose run --rm oval fetch-redhat 5 6 7 8
	docker-compose run --rm oval fetch-debian 7 8 9 10
	docker-compose run --rm oval fetch-ubuntu 12 14 16 18

.PHONY: gost
gost: ## fetch gost
	docker-compose run --rm gost fetch redhat
	docker-compose run --rm gost fetch debian

.PHONY: expliotdb
expliotdb: ## fetch expliotdb
	docker-compose run --rm go-exploitdb fetch exploitdb

.PHONY: msfdb
msfdb: ## fetch msfdb
	docker-compose run --rm go-msfdb fetch msfdb

.PHONY: up
up: ## docker-compose up
	docker-compose up -d

.PHONY: down
down: ## docker-compose down
	docker-compose down

.PHONY: help
help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
