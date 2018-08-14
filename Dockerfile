# STEP 1 build executable binary
FROM alpine:latest as builder

ARG VERSION=0.8.12

RUN apk add --update alpine-sdk wget bash linux-headers wget bash build-base && \
    cd / && \
    wget -q  https://github.com/z3APA3A/3proxy/archive/${VERSION}.tar.gz && \
    tar -xf ${VERSION}.tar.gz && \
    cd 3proxy-${VERSION} && \
    make -f Makefile.Linux

# STEP 2 build a small image
FROM alpine:latest

# STEP 1 build executable binary
RUN mkdir /etc/3proxy/

COPY --from=builder /3proxy-*/src/3proxy /usr/local/bin/
COPY 	3proxy.cfg /etc/3proxy/3proxy.cfg

RUN apk update && \
    apk upgrade && \
    apk add bash && \
    chmod -R +x /etc/3proxy

ENTRYPOINT	[ "/usr/local/bin/3proxy", "/etc/3proxy/3proxy.cfg" ]
