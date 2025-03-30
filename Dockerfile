# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.2.0
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git pkg-config nodejs

# Rails app lives here
WORKDIR /rails

# Set development environment
ENV RAILS_ENV="development" \
    BUNDLE_PATH="/usr/local/bundle"

# Install application gems
COPY Gemfile ./

# Add platforms and install gems
RUN bundle lock --add-platform x86_64-linux aarch64-linux && \
    bundle install

# Copy application code
COPY . .

# Expose port 3000
EXPOSE 3000

# Make sure the entrypoint is executable
RUN chmod +x ./bin/rails
# RUN chmod +x /rails/bin/rails

# Start the server by default, this can be overwritten at runtime
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
# CMD ["/rails/bin/rails", "server", "-b", "0.0.0.0"]
