MAVEN_IMAGE_VERSION=maven:3.6-jdk-11
ENV_FILE=$(shell pwd)/src/main/resources/application.env
ASSESSMENT_ENGINE_IMAGE_NAME=assessment_engine:latest
ASSESSMENT_ENGINE_REPACKAGE_CMD=mvn clean package spring-boot:repackage
MAVEN_REPOSITORY_CACHE=$(shell pwd)/maven_plugins
CONTAINER_CODE_DIRECTORY=/code
CONTAINER_NAME=assessment_engine
DEPENDENT_SERVICE_DOCKER_COMPOSE_FILE=$(shell pwd)/dependent_docker_services/docker-compose.yml
ASSESSMENT_ENGINE_DOCKER_NETWORK=assessment_engine_network

start: check-pre-requisites stop start-dependencies
	@command docker run -it --rm --network=$(ASSESSMENT_ENGINE_DOCKER_NETWORK) -v $(shell pwd):$(CONTAINER_CODE_DIRECTORY) -w $(CONTAINER_CODE_DIRECTORY) -v $(MAVEN_REPOSITORY_CACHE):/root/.m2 $(MAVEN_IMAGE_VERSION) $(ASSESSMENT_ENGINE_REPACKAGE_CMD)
	@command mkdir -p target/dependency && (cd target/dependency; jar -xf ../*.jar)
	@command docker build -f Dockerfile -t $(ASSESSMENT_ENGINE_IMAGE_NAME) ./
	@command docker run -d -p 28080:8080 -p 28000:8000 --env-file=$(ENV_FILE) --name $(CONTAINER_NAME) --network=$(ASSESSMENT_ENGINE_DOCKER_NETWORK) -t $(ASSESSMENT_ENGINE_IMAGE_NAME)
	@command docker logs -f $(CONTAINER_NAME)

mvn-bash: check-pre-requisites stop start-dependencies
	@command docker run -it --rm --network=$(ASSESSMENT_ENGINE_DOCKER_NETWORK) -v $(shell pwd):$(CONTAINER_CODE_DIRECTORY) -w $(CONTAINER_CODE_DIRECTORY) -v $(MAVEN_REPOSITORY_CACHE):/root/.m2 $(MAVEN_IMAGE_VERSION) bash

mvn: check-pre-requisites stop start-dependencies
	@command docker run -it --rm --network=$(ASSESSMENT_ENGINE_DOCKER_NETWORK) -v $(shell pwd):$(CONTAINER_CODE_DIRECTORY) -w $(CONTAINER_CODE_DIRECTORY) -v $(MAVEN_REPOSITORY_CACHE):/root/.m2 $(MAVEN_IMAGE_VERSION) mvn $(CMD)

stop: check-pre-requisites stop-spring stop-dependencies
	@command echo "Stopped"

stop-spring: check-pre-requisites
	@command docker rm -fv $(CONTAINER_NAME) || (echo "Already stopped")

start-dependencies: check-pre-requisites
	@command docker-compose -f $(DEPENDENT_SERVICE_DOCKER_COMPOSE_FILE) up -d
	@command ./dependent_docker_services/startup_scripts/wait_for_dependent_services_to_start.sh

stop-dependencies: check-pre-requisites
	@command docker-compose -f $(DEPENDENT_SERVICE_DOCKER_COMPOSE_FILE) down || (echo "Already stopped")

check-pre-requisites:
	@command -v docker || (echo "Docker not installed!" && exit 1)
	@command -v docker-compose || (echo "Docker compose not installed!" && exit 1)
