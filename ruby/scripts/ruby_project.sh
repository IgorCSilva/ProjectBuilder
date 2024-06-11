#!/bin/bash


read -p "Project name: " project_name
# Check if project name is provided
if [ -z "$project_name" ]; then
  echo "You must enter a project name."
  exit 1
fi

read -p "Your name: " author_name
# Check if author name is provided
if [ -z "$author_name" ]; then
  echo "You must enter an author name."
  exit 1
fi

read -p "Your email: " author_email
# Check if author email is provided
if [ -z "$author_email" ]; then
  echo "You must enter an author email."
  exit 1
fi

read -p "Write a shot summary: " short_summary
# Check if short summary is provided
if [ -z "$short_summary" ]; then
  echo "You must enter an short summary."
  exit 1
fi

read -p "Write a long description: " long_description
# Check if long description is provided
if [ -z "$long_description" ]; then
  echo "You must enter an long description."
  exit 1
fi

snake_to_pascal() {
  local input=$project_name
  # Convert to lowercase
  local lowercased=$(echo "$input" | tr '[:upper:]' '[:lower:]')
  # Replace _<char> with <Char>
  local converted=$(echo "$lowercased" | sed -r 's/_([a-z])/\U\1/g')
  # Capitalize the first character
  local pascal_case=$(echo "$converted" | sed -r 's/^(.)/\U\1/')
  echo "$pascal_case"
}

# Convert input to PascalCase
PASCAL_PROJECT_NAME=$(snake_to_pascal "$project_name")

PROJECT_NAME=$project_name

# Create the Ruby project using Bundler
bundle gem ../projects/$PROJECT_NAME

# Navigate into the project directory
cd ../projects/$PROJECT_NAME || exit

# Create Dockerfile
cat <<EOL > Dockerfile

# Use the official Ruby image from Docker Hub.
FROM ruby:3.3.1

# Set the working directory inside the container.
WORKDIR /app

# Copy the Gemfile and Gemfile.lock into the container.
COPY Gemfile* $PROJECT_NAME.gemspec ./

# Copy the version file into the container.
COPY lib/$PROJECT_NAME/version.rb ./lib/$PROJECT_NAME/version.rb

# Install dependencies using Bundler.
RUN bundle install

# Copy the rest of the application code into the container.
COPY . .

# Keeps the container available.
CMD ["tail", "-f", "/dev/null"]
EOL

# Create docker-compose.yml
cat <<EOL > docker-compose.yml
version: '3'

services:
  $PROJECT_NAME:
    build: .
    container_name: $PROJECT_NAME
    volumes:
      - .:/app
EOL


cat <<EOL > $PROJECT_NAME.gemspec
# frozen_string_literal: true

require_relative "lib/$PROJECT_NAME/version"

Gem::Specification.new do |spec|
  spec.name = "$PROJECT_NAME"
  spec.version = $PASCAL_PROJECT_NAME::VERSION
  spec.authors = ["$author_name"]
  spec.email = ["$author_email"]

  spec.summary = "$short_summary"
  spec.description = "$long_description"
  spec.homepage = "https://example.com"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://example.com"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://example.com"
  spec.metadata["changelog_uri"] = "https://example.com"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    \`git ls-files -z\`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
EOL

# Print success message
echo "Project $PROJECT_NAME created with Dockerfile and docker-compose.yml"
echo "REMEMBER to update the 'https://example.com' in $PROJECT_NAME.gemspec file later."

