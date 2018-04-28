#-----------------------------------------------------------------------------
# Global Variables
#-----------------------------------------------------------------------------

DOCKER_USER ?= $(DOCKER_USER)
DOCKER_PASS ?= 

DOCKER_BUILD_ARGS := --build-arg HTTP_PROXY=$(http_proxy) --build-arg HTTPS_PROXY=$(https_proxy)

APP_VERSION := develop-span

#-----------------------------------------------------------------------------
# BUILD
#-----------------------------------------------------------------------------

.PHONY: default build test publish build_local lint
default: depend test lint build 

depend:
	go get -d -u github.com/golang/dep
	dep ensure
test:
	go test -v ./...
build_local:
	go build 
build:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build
	docker build $(DOCKER_BUILD_ARGS) -t $(DOCKER_USER)/demo-istio:$(APP_VERSION)  .
lint:
	go get -u github.com/alecthomas/gometalinter
	gometalinter ./... --exclude=vendor --deadline=60s

#-----------------------------------------------------------------------------
# PUBLISH
#-----------------------------------------------------------------------------

.PHONY: publish 

publish: 
	docker push $(DOCKER_USER)/demo-istio:$(APP_VERSION)

#-----------------------------------------------------------------------------
# CLEAN
#-----------------------------------------------------------------------------

.PHONY: clean 

clean:
	rm -rf demo-istio


