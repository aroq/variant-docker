# Install yq
FROM mikefarah/yq as yq
COPY --from=yq /usr/bin/yq /usr/bin/yq

FROM golang:1-alpine

# Install alpine package manifest
COPY packages.txt /etc/apk/
RUN apk add --update $(grep -v '^#' /etc/apk/packages.txt)

# Install variant
ENV VARIANT_VERSION 0.32.0
RUN curl --fail -sSL -o variant.tar.gz https://github.com/mumoshu/variant/releases/download/v${VARIANT_VERSION}/variant_${VARIANT_VERSION}_linux_386.tar.gz \
    && mkdir -p variant && \
    tar -zxf variant.tar.gz -C variant \
    && cp variant/variant /usr/local/bin/ \
    && rm -fR variant.tar.gz variant \
    && chmod +x /usr/local/bin/variant

