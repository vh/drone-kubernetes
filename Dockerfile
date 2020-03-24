FROM alpine:3.11.5

ENV KUBERNETES_VERSION 1.15.10

RUN apk --no-cache add curl ca-certificates bash

RUN curl -Lo /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v${KUBERNETES_VERSION}/bin/linux/amd64/kubectl

RUN chmod +x /usr/local/bin/kubectl

COPY run.sh /

CMD ["/run.sh"]
