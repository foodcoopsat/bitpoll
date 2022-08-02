FROM python:3.10.6 AS base

ENV BITPOLL_HASH db5349f6b92f9353d85fee37cd6629fa9b74af86
ENV BITPOLL_SHA256 4888abc1df54c3d2f1ab0ee58bec4f8461a379a8724e4a5791d4bda2a9a19ad9

RUN set -ex; \
  curl -o archive.tar.gz -fSL "https://github.com/fsinfuhh/Bitpoll/archive/${BITPOLL_HASH}.tar.gz"; \
  echo "$BITPOLL_SHA256  archive.tar.gz" | sha256sum -c -; \
  tar -xzf archive.tar.gz; \
  mv -T Bitpoll* /usr/src/app; \
  rm -R archive.tar.gz; \
  cd /usr/src/app; \
  pip install mysqlclient uwsgi; \
  pip install -r requirements.txt

WORKDIR /usr/src/app

FROM base AS builder

RUN set -ex; \
  apt-get update; \
  apt-get install -y gettext npm; \
  npm install -g cssmin uglify-js; \
  rm -rf /var/lib/apt/lists/*

COPY settings_local.py bitpoll/

RUN set -ex; \
  python3 manage.py collectstatic --noinput; \
  python3 manage.py compilemessages; \
  rm bitpoll/settings_local.py

FROM base

COPY --from=builder /usr/src/app /usr/src/app

COPY settings_local.py bitpoll/

EXPOSE 80
CMD ["uwsgi", "--http", ":80", "--uid", "www-data", "--gid", "www-data", "--master", "--enable-threads", "--module", "bitpoll.wsgi", "--static-map", "/static=_static"]
