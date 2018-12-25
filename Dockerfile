FROM elixir:1.7.3

ADD . /app

ENV PATH $PATH:/usr/local/elixir/bin
RUN yes | mix local.hex
RUN yes | mix local.rebar --force
RUN yes | mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new.ez

ENV APP_HOME /app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

RUN mix deps.get
RUN mix deps.compile
RUN mix compile

EXPOSE 4000

CMD ["mix","phx.server"]
