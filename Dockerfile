FROM bitwalker/alpine-elixir:latest

# Set exposed ports
EXPOSE 80

# Cache elixir deps

ENV MIX_ENV=prod

RUN apk update && \
  apk upgrade --no-cache && \
  apk add --no-cache \
    nodejs \
    yarn \
    git \
    build-base 
add mix.exs mix.exs
add mix.lock mix.lock
RUN mix do deps.get, deps.compile
ADD . .
RUN mix compile && cd assets && yarn && yarn deploy && cd .. && mix phx.digest

# USER default
CMD [ "mix", "phx.server" ]