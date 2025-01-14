MODULE = github.com/stevesloka/envoy-xds-server

GO_BUILD_VARS = \
	github.com/projectcontour/contour/internal/build.Version=${BUILD_VERSION} \
	github.com/projectcontour/contour/internal/build.Sha=${BUILD_SHA} \
	github.com/projectcontour/contour/internal/build.Branch=${BUILD_BRANCH}

GO_LDFLAGS := -s -w $(patsubst %,-X %, $(GO_BUILD_VARS))

install: ## Build and install the binary
	go build -o $(GOPATH)/bin/envoy-xds-server -mod=readonly -v -ldflags="$(GO_LDFLAGS)" $(MODULE)/cmd/server


local-run: ## Run xDS server, envoy, and echo containers locally
	docker run -d --rm --name=echo9100 -p 9100:8080 stevesloka/echo-server echo-server --echotext=Sample-Endpoint!
	docker run -d --rm --name=echo9101 -p 9101:8080 stevesloka/echo-server echo-server --echotext=Sample-Endpoint!
	docker run -d --rm --name=echo9102 -p 9102:8080 stevesloka/echo-server echo-server --echotext=Sample-Endpoint!
	docker run -d --rm --name=echo9103 -p 9103:8080 stevesloka/echo-server echo-server --echotext=Sample-Endpoint!
	docker run -d --rm --name=echo9104 -p 9104:8080 stevesloka/echo-server echo-server --echotext=Sample-Endpoint!
	nohup go run cmd/server/main.go > xds_server.log 2>&1 &
	./hack/start-envoy.sh


local-cleanup: ## Stop all containers and processes
	-docker stop echo9100 echo9101 echo9102 echo9103 echo9104
	-pkill -f "go run cmd/server/main.go"
	-pkill envoy

.PHONY: install local-run local-cleanup