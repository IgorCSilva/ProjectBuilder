# Use the official Ruby image from Docker Hub
FROM ruby:3.3.1

# Set the working directory inside the container
WORKDIR /app

COPY Gemfile ./

# Install dependencies using Bundler
# RUN gem install rails
RUN bundle install

# Keeps the container available.
CMD ["tail", "-f", "/dev/null"]