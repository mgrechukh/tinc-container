# syntax=docker/dockerfile:experimental
FROM alpine:3.11 as tinc-build
ENV TINC_VERSION=1.1pre17
RUN apk add --update -t .tinc-build-deps \
           autoconf \
           build-base \
           curl \
           g++ \
           gcc \
           libc-utils \
           libpcap-dev \
           libressl \
           linux-headers \
           lzo-dev \
           make \
           ncurses-dev \
           openssl-dev \
           readline-dev \
           tar \
           zlib-dev
ADD http://www.tinc-vpn.org/packages/tinc-${TINC_VERSION}.tar.gz /src/tinc/
RUN cd /src/tinc && tar xzvf tinc-${TINC_VERSION}.tar.gz --strip 1 \
	&& ./configure --sysconfdir=/etc --localstatedir=/var \
	&& make

FROM alpine:3.11
RUN apk add --no-cache readline ncurses lzo
COPY --from=tinc-build /src/tinc/src/tincd /src/tinc/src/tinc /usr/local/bin/
EXPOSE 655/tcp 655/udp
