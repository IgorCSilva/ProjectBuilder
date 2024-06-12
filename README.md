# Project Builder

Create projects ready to run and develop.

## How to create a ruby project

### A simple ruby project

The project will be created with Dockerfile, docker-compose and updated gemspec file.

Run the project builder:  
`cd ruby`  
`docker-compose up --build`

In another terminal get inside the container and run the script to create the simple ruby project:  
`docker exec -it ruby_project_builder bash`  
`cd scripts`  
`./ruby_project.sh`

Then, the creation flow will guide you with some questions.

At the end, you will have a project ready to up.

In another terminal, inside the project created build it running:  
`docker-compose up --build`

Again, in a separate shell, get inside the new project container and run the tests:  
`docker exec -it {project_name} bash`  
`rspec`

### A rails project

The project will be created with Dockerfile, docker-compose.

Run the project builder:  
`cd ruby`  
`docker-compose up --build`

In another terminal get inside the container and run the script to create the rails project:  
`docker exec -it ruby_project_builder bash`  
`cd scripts`  
`./rails_project.sh`

Then, the creation flow will guide you with some questions.

At the end, you will have a project ready to up.

In another terminal, inside the project created build it running:  
`docker-compose up --build`

At this point, you will be able to access `localhost:3000` and see the initial rails page.

To interact with the project you can get inside the container:  
`docker exec -it {project_name} bash`  