
# https://hub.docker.com/_/golang
ARG GO_IMAGE_VERSION
# https://github.com/caddyserver/xcaddy/releases
ARG XCADDY_VERSION
# https://hub.docker.com/_/alpine
ARG ALPINE_VERSION
# https://github.com/caddyserver/caddy/releases
ARG CADDY_VERSION
# https://github.com/caddy-dns/cloudflare/tags
ARG CADDY_CF_DNS_VERSION


FROM golang:${GO_IMAGE_VERSION} AS builder

ARG XCADDY_VERSION
ARG CADDY_CF_DNS_VERSION

# Configures xcaddy to not clean up post-build (unnecessary in a container)
ENV XCADDY_SKIP_CLEANUP=1
# Sets capabilities for output caddy binary to be able to bind to privileged ports
ENV XCADDY_SETCAP=1

RUN apk add --no-cache \
    ca-certificates \
    curl \
    git \
    libcap

RUN set -eux; \
    apkArch="$(apk --print-arch)"; \
    case "$apkArch" in \
        x86_64)  binArch='amd64' ;; \
        armhf)   binArch='armv5' ;; \
        armhf)   binArch='armv6' ;; \
        armv7)   binArch='armv7' ;; \
        aarch64) binArch='arm64' ;; \
        ppc64el|ppc64le) binArch='ppc64le' ;; \
        riscv64) binArch='riscv64' ;; \
        s390x)   binArch='s390x' ;; \
        *) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
    esac; \
    wget -O /tmp/xcaddy.tar.gz "https://github.com/caddyserver/xcaddy/releases/download/v${XCADDY_VERSION}/xcaddy_${XCADDY_VERSION}_linux_${binArch}.tar.gz"; \
    tar x -z -f /tmp/xcaddy.tar.gz -C /usr/bin xcaddy; \
    rm -f /tmp/xcaddy.tar.gz; \
    chmod +x /usr/bin/xcaddy;

WORKDIR /usr/bin

RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare@${CADDY_CF_DNS_VERSION}



### second stage for dist image

FROM alpine:${ALPINE_VERSION}

ARG CADDY_VERSION

RUN apk add --no-cache \
    ca-certificates \
    curl \
    libcap \
    mailcap

# avoiding a separate COPY command to reduce image size
RUN --mount=target=/tmp/builder,from=builder,source=/usr/bin cp /tmp/builder/caddy /usr/bin/caddy; \
    set -eux; \
    mkdir -p \
        /config/caddy \
        /data/caddy \
        /etc/caddy \
        /usr/share/caddy \
        /data/builder \
    ; \
    chmod 1777 /config/caddy /data/caddy; \
    setcap cap_net_bind_service=+ep /usr/bin/caddy; \
    chmod +x /usr/bin/caddy; \
    wget -O /etc/caddy/Caddyfile "https://raw.githubusercontent.com/caddyserver/dist/refs/tags/v${CADDY_VERSION}/config/Caddyfile"; \
    wget -O /usr/share/caddy/index.html "https://raw.githubusercontent.com/caddyserver/dist/refs/tags/v${CADDY_VERSION}/welcome/index.html"

# See https://caddyserver.com/docs/conventions#file-locations for details
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

LABEL org.opencontainers.image.version=v${CADDY_VERSION}
LABEL org.opencontainers.image.title=Caddy
LABEL org.opencontainers.image.description="multi platform linux images for Caddy with custom plugin(s)"
LABEL org.opencontainers.image.url=https://caddyserver.com
LABEL org.opencontainers.image.documentation=https://caddyserver.com/docs
LABEL org.opencontainers.image.vendor="Francesco Gianni"
LABEL org.opencontainers.image.licenses=Apache-2.0
LABEL org.opencontainers.image.source="https://github.com/gfrancesco/caddy-plugins"

EXPOSE 80
EXPOSE 443
EXPOSE 443/udp
EXPOSE 2019

WORKDIR /srv

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]