NAME = "redis"
GIT_SHORT_COMMIT=`git rev-parse --short HEAD`

DATE=`date +%Y-%m-%d`

all: build

redis:
	docker build -t segura/$(NAME):build -f Dockerfile .

build: redis

tag:
	echo "Tagging commit_${GIT_SHORT_COMMIT} and branch_${GIT_BRANCH}"
	docker tag segura/$(NAME):build 	index.segurasystems.com/$(NAME):$(DATE)
	docker tag segura/$(NAME):build 	index.segurasystems.com/$(NAME):commit_$(GIT_SHORT_COMMIT)
	docker tag segura/$(NAME):build  	index.segurasystems.com/$(NAME):branch_$(GIT_BRANCH)
	docker tag segura/$(NAME):build  	index.segurasystems.com/$(NAME):build_$(BUILD_NUMBER)
	docker tag segura/$(NAME):build 	index.segurasystems.com/$(NAME):latest

push-to-repo:
	docker push index.segurasystems.com/$(NAME):$(DATE)
	docker push index.segurasystems.com/$(NAME):commit_$(GIT_SHORT_COMMIT)
	docker push index.segurasystems.com/$(NAME):branch_$(GIT_BRANCH)
	docker push index.segurasystems.com/$(NAME):build_$(BUILD_NUMBER)
	docker push index.segurasystems.com/$(NAME):latest

push: build tag push-to-repo

release-to-repo:
	docker tag segura/$(NAME):build index.segurasystems.com/$(NAME):stable

release: push release-to-repo
	docker push index.segurasystems.com/$(NAME):stable
