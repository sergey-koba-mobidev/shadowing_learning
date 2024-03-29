ARG RUBY_VERSION
FROM ruby:$RUBY_VERSION-slim-bullseye

ARG PG_MAJOR
ARG NODE_MAJOR
ARG YARN_VERSION

RUN apt update -qq && apt upgrade -y

# Common dependencies
RUN apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
  build-essential \
  apt-transport-https \
  ca-certificates \
  libicu-dev \
  gnupg2 \
  curl \
  less \
  git \
  mc \
  sox \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

# Download MIME types database for mimemagic (only if you use it)
# RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
#   DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
#     shared-mime-info \
#   && cp /usr/share/mime/packages/freedesktop.org.xml ./ \
#   && apt-get remove -y --purge shared-mime-info \
#   && apt-get clean \
#   && rm -rf /var/cache/apt/archives/* \
#   && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
#   && truncate -s 0 /var/log/*log \
#   && mkdir -p /usr/share/mime/packages \
#   && cp ./freedesktop.org.xml /usr/share/mime/packages/

# Add PostgreSQL to sources list
RUN curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
  && echo 'deb http://apt.postgresql.org/pub/repos/apt/ bullseye-pgdg main' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list

# Add NodeJS to sources list
RUN curl -sL https://deb.nodesource.com/setup_$NODE_MAJOR.x | bash -

# Add Yarn to the sources list
RUN curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list

# Install dependencies
RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
  libpq-dev \
  postgresql-client-$PG_MAJOR \
  nodejs \
  yarn=$YARN_VERSION-1 && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  truncate -s 0 /var/log/*log

# Configure bundler
ENV LANG=C.UTF-8 \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3

RUN gem update --system

# Create a directory for the app code
RUN mkdir -p /app

WORKDIR /app
