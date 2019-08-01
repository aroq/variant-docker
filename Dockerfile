FROM mikefarah/yq as yq

FROM golang:1-alpine

COPY --from=yq /usr/bin/yq /usr/bin/yq

# Install alpine package manifest
COPY packages.txt /etc/apk/
RUN apk add --update $(grep -v '^#' /etc/apk/packages.txt)

RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \
  direnv

# Install variant
RUN git clone https://github.com/aroq/variant.git && \
  cd variant && \
  git checkout unstable && \
  go build && \
  cp variant /usr/bin/
