# Layer - Infrastructure / Containerisation

FROM ruby:3.2-slim AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle config set --local without 'development test' \
    && bundle install --jobs 4 --retry 3

FROM ruby:3.2-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq5 \
    && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home railtrack
USER railtrack
WORKDIR /home/railtrack/app

COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --chown=railtrack:railtrack . .

EXPOSE 9292

CMD ["sh", "-c", "bundle exec puma -p ${PORT:-9292}"]