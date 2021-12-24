FROM debian:buster-slim

LABEL org.opencontainers.image.authors="dirk@reher.me" \
    reher.me.version="1.0" \
	reher.me.release-date="24.12.2021" \
	org.label-schema.name="Let's Shorten That URL" \
	org.label-schema.build-date=$BUILD_DATE

RUN apt-get update \
	&& apt-get install --no-install-recommends -y \
	build-essential \
	libssl-dev \
	zlib1g-dev \
	curl  \
	gosu \
	libpng-dev \
	memcached \
	libio-socket-ssl-perl \
	libpod-parser-perl \
	libtest-pod-coverage-perl \
	libpod-coverage-perl \
	libnet-google-safebrowsing2-perl \
	&& rm -rf /var/lib/apt/lists/*

RUN cpan Carton

COPY /lstu /usr/lstu

WORKDIR /usr/lstu

RUN carton install --deployment --without=test --without=postgresql --without=mysql --without=ldap --without=htpasswd

ENV CONTACT="example@mail.eu" \
	LISTEN="'http://0.0.0.0:8080'" \
	THEME="default" \
	URL_LENGTH=8 \
	PROVIS_STEP=5 \
	PAGE_OFFSET=10 \
	PROVISIONING=100 \
	URL_PREFIX="/" \
	BAN_MIN_STRIKE=3 \
	SESSION_DURATION=3600 \
	X_FRAME="DENY" \
	MAX_REDIR=2 \
	SKIP_SPAMHAUS=0 \
	X_CONTENT_TYPE="nosniff" \
	X_XSS_PROTECTION="1; mode=block" \
	LOG_CREATOR_IP=0 \
	CSP="default-src 'none'; script-src 'self'; style-src 'self'; img-src 'self' data:; font-src 'self'; form-action 'self'; base-uri 'self'" \
	UID=1000 \
	GID=1000

COPY lstu.conf .
COPY docker-entrypoint.sh .

RUN chmod u+x docker-entrypoint.sh

VOLUME ["/usr/lstu/db"]

CMD ["carton", "exec", "hypnotoad", "/usr/lstu/script/lstu"]

ENTRYPOINT ["/usr/lstu/docker-entrypoint.sh"]

HEALTHCHECK CMD curl --fail http://127.0.0.1:8080/ || exit 1
EXPOSE 8080