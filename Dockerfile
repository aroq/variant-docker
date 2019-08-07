FROM mikefarah/yq as yq

FROM golang:1-alpine as builder
# Install alpine package manifest
COPY packages.txt /etc/apk/
RUN apk add --no-cache --update $(grep -v '^#' /etc/apk/packages.txt)
RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \
  direnv
# Install variant
RUN git clone https://github.com/aroq/variant.git && \
  cd variant && \
  git checkout unstable && \
  go build && \
  cp variant /usr/bin/

FROM alpine:3.10.1
COPY --from=yq /usr/bin/yq /usr/bin/yq
COPY --from=builder /usr/bin/variant /usr/bin/variant
