SHELL := /bin/bash
NAME = "redis"
GIT_SHORT_COMMIT=$(shell git rev-parse --short HEAD)
DATE=$(shell date +%Y-%m-%d)
DEF_REPO=index.segura.cloud
AWS_REPO_LOOKUP=$(shell nslookup -type=cname index.segura.cloud | grep ".dkr.ecr.eu-west-1.amazonaws.com" -m 1 | awk '{print $$NF}' | sed 's/\.$$//')

ifndef REPO
ifneq ($(AWS_REPO_LOOKUP),)
REPO=$(AWS_REPO_LOOKUP)
else
REPO=$(DEF_REPO)
endif
endif
ifndef GIT_BRANCH
GIT_BRANCH:=$(shell git rev-parse --abbrev-ref HEAD | sed 's/[^a-zA-Z0-9]/\_/g' | sed -e 's/\(.*\)/\L\1/')
endif
ifndef BUILD_NUMBER
BUILD_NUMBER=local
endif


all: build

redis:
	docker build --squash -t segura/$(NAME):build -f Dockerfile .

build: redis

tag:
	echo "Tagging commit_${GIT_SHORT_COMMIT} and branch_${GIT_BRANCH}"
	docker tag segura/$(NAME):build 	$(REPO)/$(NAME):$(DATE)
	docker tag segura/$(NAME):build 	$(REPO)/$(NAME):commit_$(GIT_SHORT_COMMIT)
	docker tag segura/$(NAME):build  	$(REPO)/$(NAME):branch_$(GIT_BRANCH)
	docker tag segura/$(NAME):build  	$(REPO)/$(NAME):build_$(BUILD_NUMBER)
	docker tag segura/$(NAME):build 	$(REPO)/$(NAME):latest

push-to-repo:
	docker push $(REPO)/$(NAME):$(DATE)
	docker push $(REPO)/$(NAME):commit_$(GIT_SHORT_COMMIT)
	docker push $(REPO)/$(NAME):branch_$(GIT_BRANCH)
	docker push $(REPO)/$(NAME):build_$(BUILD_NUMBER)
	docker push $(REPO)/$(NAME):latest

push: build tag push-to-repo

release-to-repo:
	docker tag segura/$(NAME):build $(REPO)/$(NAME):stable

release: push release-to-repo
	docker push $(REPO)/$(NAME):stable
