# syntax=docker/dockerfile:experimental
FROM ruby:3.1.1-bullseye

RUN apt-get update && apt-get install -y --no-install-recommends \
  vim=2:8.2.2434-3+deb11u1 \
  && rm -rf /var/lib/apt/lists/*

ENV LANG=C.UTF-8 \
EDITOR=vim \
BUNDLE_PATH="/bundle" \
HOME="/home/app/" \
PATH="/app/bin:${PATH}"

RUN useradd -m app && \
  mkdir /app && \
  mkdir "${BUNDLE_PATH}" && \
  chown app:app -Rv /app "${BUNDLE_PATH}"

USER app
WORKDIR /app

COPY --chown=app:app Gemfile* ./

RUN bundle install -j4 --retry 3 \
 && rm -rf /bundle/cache/*.gem

COPY --chown=app:app . .

CMD ["run"]
