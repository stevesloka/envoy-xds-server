# Envoy XDS Server

This is a sample repo which demonstrates how to spin up an xDS Server for Envoy Proxy. 

## Sample Config File

```yaml
name: testconfig
spec: 
  listeners:
  - name: listener_0
    address: 0.0.0.0
    port: 9000
    routes:
    - name: echoroute
      prefix: /
      clusters:
      - echo
  clusters:
  - name: echo
    endpoints:
    - address: 127.0.0.1
      port: 9101
    - address: 127.0.0.1
      port: 9102
```

## Sample Apps

Run some sample apps in docker to give some endpoints to route to:
```
docker run -d --rm --name=echo9100 -p 9100:8080 stevesloka/echo-server echo-server --echotext=Sample-Endpoint!
docker run -d --rm --name=echo9101 -p 9101:8080 stevesloka/echo-server echo-server --echotext=Sample-Endpoint!
docker run -d --rm --name=echo9102 -p 9102:8080 stevesloka/echo-server echo-server --echotext=Sample-Endpoint!
docker run -d --rm --name=echo9103 -p 9103:8080 stevesloka/echo-server echo-server --echotext=Sample-Endpoint!
docker run -d --rm --name=echo9104 -p 9104:8080 stevesloka/echo-server echo-server --echotext=Sample-Endpoint!
```

## Stop All Sample Apps

Stop all the sample endpoints created in the previous step:
```
docker stop echo9100
docker stop echo9101
docker stop echo9102
docker stop echo9103
docker stop echo9104
```
