# Railtrack

# ----- Section 1 - API Summary -----

Railtrack is a RESTful JSON API that can be used to:
-- Search for rail journeys.
-- Manage bookings. 

The Railtrack API has been built using Ruby, Sinatra, and PostgreSQL.

# ----- Section 2 - API Structure -----

railtrack/
|
|── app/
|   |
|   |__ controllers/        # HTTP layer - route handlers
|   |   |__ application_controller.rb
|   |   |__ stations_controller.rb
|   |   |__ journeys_controller.rb
|   |   |__ bookings_controller.rb
|   |
|   |__ models/     # Domain layer - ActiveRecord + validations
|   |   |__ station.rb
|   |   |__ journey.rb
|   |   |__ fare.rb
|   |   |__ booking.rb
|   |   |__ passenger.rb
|   |
|   |── serializers/        # Presentation layer — shape JSON output
|   |   |__ station_serializer.rb
|   |   |__ journey_serializer.rb
|   |   |__ booking_serializer.rb
|   |
|   |__ services/       # Business logic layer
|       |__ journey_search_service.rb
|       |__ booking_creation_service.rb
|       |__ reference_generator.rb
|
|__ config/
|   |__ application.rb      # App bootstrap + middleware
|   |__ database.yml
|
|__ db/
|   |
|   |__ migrate/        # Versioned schema changes
|   |   |__ 001_create_stations.rb
|   |   |__ 002_create_journeys.rb
|   |   |__ 003_create_fares.rb
|   |   |__ 004_create_bookings.rb
|   |   |__ 005_create_passengers.rb
|   |
|   |__ seeds.rb
|
|__ spec/       # Test suite (mirrors app/ structure)
|   |__ controllers/
|   |__ models/
|   |__ services/
|   |__ support/
|       |__ database_cleaner.rb
|       |__ factory_helpers.rb
|
|__ lib/tasks/db.rake
|
|__ .github/workflows/ci.yml        # GitHub Actions CI pipeline
|
|__ config.ru       # Rack entry point
|
|__ Gemfile
|
|__ Dockerfile
|
|__ docker-compose.yml

# ----- Section 3 - Getting Started -----


## ----- Section 3 - Step 1 -----

Make sure you have installed Docker desktop. Once you have installed Docker desktop, you will need to download the railtrack project to your local machine using the following commands:

``` bash

git clone https://github.com/yourname/railtrack.git
cd railtrack

```


## ----- Section 3 - Step 2 -----

Copy the example environment file (.env) using the following command:

``` bash

cp .env.example .env

```


## ----- Section 3 - Step 3 -----

Build the Docker image, start PostgreSQL, run migrations, seed sample data, and start the API server. This might take between 1–2 minutes when started for the first time.

``` bash

docker compose up --build

```

The Railtrack API is now running at http://localhost:9292. You will need to open a new terminal tab to run commands against it.


## ----- Section 3 - Step 4 -----

Once the Docker image is built, use the following command to start the API faster next time:

``` bash

docker compose up

```
Stop all containers. Your database will be preserved for next time.

``` bash

docker compose down

```

## ----- Section 3 - Step 5 -----

Use curl to verify that the server is up and that the database is seeded

``` bash

curl http://localhost:9292/health

curl http://localhost:9292/stations

```

## ----- Section 3 - Step 6 -----

Open a new terminal and run the following commands:

``` bash

bundle exec rspec # all tests
COVERAGE=true bundle exec rspec # with coverage report
bundle exec rspec spec/models/fare_spec.rb # single file

