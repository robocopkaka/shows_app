# README

## Prerequisites

* Rails - 6.0.2.2
* Ruby - 2.5.3
* Postgresql
* Redis

## Installation Steps
* Clone this repo
* `cd` into the repo
* run `bundle install` to install dependencies
* Run `rails credentials:edit`
* Add a key  - `db_user` and a value representing your database username
* Add a key - `db_password` and a value representing your database password
* Add a key - `REDIS_URL` which points to the Redis instance running on your machine
* Save your new credentials
* Run  `rails db:create` to create the database
* Run `rails db:migrate` to create all the  necessary tables. 
* Alternatively, you can run `rails schema:load`
* Run `rails db:seed` to seed the database with initial values
* Start the app by running `rails s`

## Tests
* Run `rspec spec` to run all the tests
* Run `open coverage/index.html` if you're using a Mac or `xdg-open coverage/index.html` if you're using a Debian/Ubuntu setup to show the coverage report
* If on Windows or other operating systems, go to the `coverage` folder in the root directory, which is generated the first time tests are run, and open the `index.html` file in your browser

## Endpoints
### Key Endpoints
* Add show to library - `POST http://localhost:3000/users/:user_id/libraries`
* Return all shows in a user's library - `GET http://localhost:3000/users/:user_id/libraries`
* Return all movies and seasons - `GET http://localhost:3000/all_shows`
* Endpoint to return movies - `GET http://localhost:3000/movies`
* Endpoint to return seasons with their episodes: `GET http://localhost:3000/seasons`

### Other Endpoints
* Endpoint to create users - `POST http://localhost:3000/users`
* Endpoint to create movies - `POST http://localhost:3000/movies`
* Endpoint to update movies - `PATCH http://localhost:3000/movies/:id`
* Endpoint to delete movies - `DELETE http://localhost:3000/movies/:id`
* Endpoint to fetch a single movie - `GET http://localhost:3000/movies/:id`
* Endpoint to create seasons - `POST http://localhost:3000/seasons`
* Endpoint to update seasons - `PATCH http://localhost:3000/seasons/:id`
* Endpoint to delete seasons - `DELETE http://localhost:3000/seasons/:id`
* Endpoint to retrieve a single season - `GET http://localhost:3000/seasons/:id`
* Endpoint to update episodes - `PATCH http://localhost:3000/seasons/:season_id/episodes/:id`
* Endpoint to delete episodes - `DELETE http://localhost:3000/seasons/:season_id/episodes/:id`
* Endpoint to fetch a single episode - `GET http://localhost:3000/seasons/:season_id/episodes/:id`

## Assumptions
* Only cached index methods and didn't cache finder methods, i.e `find_by!` since I wasn't sure how best to invalidate them
* I created a variants table for video quality, i.e `HD` and `SD`
* Each movie and season has two variant entries
* For adding shows to library, I wasn't sure if adding a payment library was necessary so I just made an assumption that all payments were successful


## Things I couldn't finish
* Setting up a relationship between `variants` and `episodes`
* Preventing users from buying multiple variants of the same show. I wasn't sure of the best approach to take regarding this and left it as is.
* Setting up pagination

