FROM golang:1-alpine as builder

# Install alpine package manifest
COPY packages.txt /etc/apk/
RUN apk add --no-cache --update $(grep -v '^#' /etc/apk/packages.txt)

# Install variant
RUN git clone https://github.com/aroq/variant.git && \
  cd variant && \
  git checkout unstable && \
  go build && \
  cp variant /usr/bin/

FROM alpine:3.10.1
COPY --from=builder /usr/bin/variant /usr/bin/variant

# Install alpine package manifest
COPY packages.txt /etc/apk/
RUN apk add --no-cache --update $(grep -v '^#' /etc/apk/packages.txt)
