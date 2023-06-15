#!make
include .env
export $(shell sed 's/=.*//' .env)
include RELEASE
export $(shell sed 's/=.*//' RELEASE)
#include bundler.env
#export $(shell sed 's/=.*//' bundler.env)
 ### IMAGE := coms-comsh:1.1.0
 ### CONTAINER := coms-comsh
 ### IMAGE := $(cat CONTAINER):$(cat version)
 ### CONTAINER := $(cat CONTAINER)
 ### DBVERSION := 3
 ### DBVERSION := 202103311156
#BASE_IMAGE := das-base:0.1.0
SSHKEY_PATH := /root/.ssh
APP_SRC_PATH := $(realpath ../)
WORKDIR := /app
ENV_FILE := bundler.env


SRCHOST := $(SRC_MYSQL_HOST)
DSTHOST := $(DST_MYSQL_HOST)

test:
	$(SRCHOST) $(DBVERSION) $(IMAGE) $(TAG)

bundle-check:
	docker run --rm -it --env-file $(ENV_FILE) -v $(APP_SRC_PATH):$(WORKDIR) -v $(SSHKEY_PATH):$(SSHKEY_PATH) -w $(WORKDIR) $(BASE_IMAGE):$(BASE_IMAGE_TAG) bundle check
bundle-update:
	docker run --rm -it --env-file $(ENV_FILE) -v $(APP_SRC_PATH):$(WORKDIR) -v $(SSHKEY_PATH):$(SSHKEY_PATH) -w $(WORKDIR) $(BASE_IMAGE):$(BASE_IMAGE_TAG) bundle update
bundle-install:
	docker run --rm -it --env-file $(ENV_FILE) -v $(APP_SRC_PATH):$(WORKDIR) -v $(SSHKEY_PATH):$(SSHKEY_PATH) -w $(WORKDIR) $(BASE_IMAGE):$(BASE_IMAGE_TAG) bundle install
bundle-show:
	docker run --rm -it --env-file $(ENV_FILE) -v $(APP_SRC_PATH):$(WORKDIR) -v $(SSHKEY_PATH):$(SSHKEY_PATH) -w $(WORKDIR) $(BASE_IMAGE):$(BASE_IMAGE_TAG) bundle show $(GEM)
bundle-bash:
	docker run --rm -it --env-file $(ENV_FILE) -v $(APP_SRC_PATH):$(WORKDIR) -v $(SSHKEY_PATH):$(SSHKEY_PATH) -w $(WORKDIR) $(BASE_IMAGE):$(BASE_IMAGE_TAG) /bin/bash



build:
	docker build -f Dockerfile $(APP_SRC_PATH) -t ${REPO_PATH}$(IMAGE):$(TAG)
build-test:
	### docker build -f Dockerfile $(APP_SRC_PATH) -t ${REPO_PATH}$(IMAGE):$(TAG) || make bash IMAGE=$$(docker images -aq | head -1)
build-base:
	docker build -f Dockerfile-base $(APP_SRC_PATH) -t $(BASE_IMAGE):$(BASE_IMAGE_TAG)
build-app:
	docker build -f Dockerfile-app $(APP_SRC_PATH) -t ${REPO_PATH}$(IMAGE):$(TAG)
build-das:
	docker rmi $$(docker images|grep ${REPO_PATH}${IMAGE} | grep ${TAG} |head -1 |awk '{print $$3}')
	docker rmi $$(docker images|grep ${BASE_IMAGE} | grep ${BASE_IMAGE_TAG} |head -1 |awk '{print $$3}')
	docker build -f Dockerfile-base $(APP_SRC_PATH) -t $(BASE_IMAGE):$(BASE_IMAGE_TAG)
	docker run --rm -it --env-file $(ENV_FILE) -v $(APP_SRC_PATH):$(WORKDIR) -v $(SSHKEY_PATH):$(SSHKEY_PATH) -w $(WORKDIR) $(BASE_IMAGE):$(BASE_IMAGE_TAG) bundle install
	docker build -f Dockerfile-app $(APP_SRC_PATH) -t ${REPO_PATH}$(IMAGE):$(TAG)

push:
	docker push ${REPO_PATH}${IMAGE}:${TAG}

rmi:
	docker rmi $$(docker images|grep ${REPO_PATH}${IMAGE} | grep ${TAG} |head -1 |awk '{print $$3}')


create:
	docker rm $(CONTAINER) ; docker create --name $(IMAGE) ${REPO_PATH}$(IMAGE):$(TAG) /bin/bash
create-base:
	 docker create --name $(BASE_IMAGE) $(BASE_IMAGE):$(BASE_IMAGE_TAG) /bin/bash
#bash:
#	docker run -it $(CONTAINER) /bin/bash

bash:
	docker run --rm -it -v $(SSHKEY_PATH):$(SSHKEY_PATH) ${REPO_PATH}$(IMAGE):$(TAG) /bin/bash
bash-base:
	docker run --rm -it -v $(SSHKEY_PATH):$(SSHKEY_PATH) $(BASE_IMAGE):$(BASE_IMAGE_TAG) /bin/bash

attach:
	${INFO} "Attaching to container $$(docker ps | grep $(IMAGE) | head -1 | awk '{print $$1}')..."
	docker exec -it $$(docker ps | grep $(IMAGE) | head -1 | awk '{print $$1}') /bin/bash
logs:
	docker logs -f $$(docker ps | grep $(IMAGE) | head -1 | awk '{print $$1}')
#execute:
#	docker run --rm -it $(CONTAINER) bash -c '$(COMMAND)'

dst.db.up:
	${INFO} "DB migration Started..."
	docker-compose run --rm admin /app/scripts/wait-for-it.sh $(DSTHOST):3306 -t 60 -- /app/scripts/db-migrate.sh dst up
	${INFO} "DB migration Done..."

dst.db.down:
	${INFO} "DB migration Started..."
	docker-compose run --rm admin /app/scripts/wait-for-it.sh $(DSTHOST):3306 -t 60 -- /app/scripts/db-migrate.sh dst down
	${INFO} "DB migration Done..."

dst.db.to:
	${INFO} "DB migration Started..."
	docker-compose run --rm admin /app/scripts/wait-for-it.sh $(DSTHOST):3306 -t 60 -- ./scripts/db-migrate.sh dst to $(DBVERSION)
	${INFO} "DB migration Done..."

dst.db.load:
	${INFO} "Sample data loading Started..."
	docker-compose run --rm admin /app/scripts/wait-for-it.sh $(DSTHOST):3306 -t 60 -- /app/scripts/load-sample-data.sh dst
	${INFO} "Sample data loading Done..."

src.db.up:
	${INFO} "DB migration Started..."
	docker-compose run --rm admin /app/scripts/wait-for-it.sh $(SRCHOST):3306 -t 60 -- /app/scripts/db-migrate.sh src up
	${INFO} "DB migration Done..."

src.db.down:
	${INFO} "DB migration Started..."
	docker-compose run --rm admin /app/scripts/wait-for-it.sh $(SRCHOST):3306 -t 60 -- /app/scripts/db-migrate.sh src down
	${INFO} "DB migration Done..."

src.db.to:
	${INFO} "DB migration Started..."
	docker-compose run --rm admin /app/scripts/wait-for-it.sh $(SRCHOST):3306 -t 60 -- /app/scripts/db-migrate.sh src to $(DBVERSION)
	${INFO} "DB migration Done..."

src.db.load:
	${INFO} "Sample data loading Started..."
	docker-compose run --rm admin /app/scripts/wait-for-it.sh $(SRCHOST):3306 -t 60 -- /app/scripts/load-sample-data.sh src
	${INFO} "Sample data loading Done..."


# Cosmetics
YELLOW := "\e[1;33m"
NC := "\e[0m"

# Shell Functions
INFO := @bash -c '\
  printf $(YELLOW); \
  echo ">>> $$1"; \
  printf $(NC)' SOME_VALUE
