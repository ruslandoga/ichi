#########
# BUILD #
#########

FROM hexpm/elixir:1.18.4-erlang-28.0-alpine-3.21.3 AS build

# install build dependencies
RUN apk add --no-cache --update git build-base

# prepare build dir
RUN mkdir /app
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config/config.exs config/
RUN mix deps.get
RUN mix deps.compile

# build project
COPY lib lib
RUN mix compile
COPY config/runtime.exs config/

# build release
RUN mix release

#######
# APP #
#######

FROM alpine:3.22.0 AS app

RUN adduser -S -H -u 999 -G nogroup ichi
RUN apk add --no-cache --update openssl libgcc libstdc++ ncurses
COPY --from=build /app/_build/prod/rel/ichi /ichi
RUN mkdir -p /data && chmod ugo+rw -R /data

USER 999

WORKDIR /ichi
ENV HOME=/ichi
ENV ICHIPATH=/data
VOLUME /data

CMD ["/app/bin/ichi", "start"]
