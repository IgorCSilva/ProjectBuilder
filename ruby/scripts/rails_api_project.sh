#!/bin/bash


read -p "Project name: " project_name
# Check if project name is provided
if [ -z "$project_name" ]; then
  echo "You must enter a project name."
  exit 1
fi

PROJECT_NAME=$project_name

# Navigate into the projects folder
cd ../projects || exit

# Create the rails project
rails new $PROJECT_NAME --api

# Navigate into the project directory
cd $PROJECT_NAME || exit

# Create Dockerfile
cat <<EOL > Dockerfile.project

FROM ruby:3.3.1

RUN apt-get update -yqq \\
  && apt-get install -yqq --no-install-recommends \\
    libqt5webkit5-dev \\
  && apt-get -q clean \\
  && rm -rf /var/lib/apt/lists

WORKDIR /app
COPY Gemfile* ./
RUN bundle install
COPY . .

# Specify the command to run the application
CMD ["rails", "server", "-b", "0.0.0.0"]
EOL

# Create docker-compose.yml
cat <<EOL > docker-compose.yml
version: '3'

services:
  $PROJECT_NAME:
    build:
      context: .
      dockerfile: Dockerfile.project
    container_name: $PROJECT_NAME
    ports:
      - "3000:3000"
    volumes:
      - .:/app
EOL

# Print success message
echo "Project $PROJECT_NAME created with Dockerfile and docker-compose.yml"

