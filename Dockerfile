FROM mikefarah/yq as yq

FROM alpine:3.10.1

COPY --from=yq /usr/bin/yq /usr/bin/yq

# Install alpine package manifest
COPY packages.txt /etc/apk/
RUN apk add --no-cache --update $(grep -v '^#' /etc/apk/packages.txt)

# Install variant
ENV VARIANT_VERSION 0.32.0
RUN curl --fail -sSL -o variant.tar.gz https://github.com/mumoshu/variant/releases/download/v${VARIANT_VERSION}/variant_${VARIANT_VERSION}_linux_386.tar.gz \
    && mkdir -p variant && \
    tar -zxf variant.tar.gz -C variant \
    && cp variant/variant /usr/bin/ \
    && rm -fR variant.tar.gz variant \
    && chmod +x /usr/bin/variant

