# Use the official Ruby image from Docker Hub
FROM ruby:3.3.1

# Set the working directory inside the container
WORKDIR /app

# Install dependencies using Bundler
RUN gem install rails

# Keeps the container available.
CMD ["tail", "-f", "/dev/null"]