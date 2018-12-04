# drone-kubernetes

## Usage example
```
deploy:
  image: maki/drone-kubernetes
  deployment: mydeployment
  repo: myorg/myrepo
  container: app
  tag: "${DRONE_COMMIT_SHA}"
  secrets: [ kubernetes_server, kubernetes_token, kubernetes_cert ]
  when:
    event: push
    branch: master
```
