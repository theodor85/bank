# README

## How to launch

Clone this repo:

    git clone git@github.com:theodor85/bank.git
    cd bank

Launch docker-compose (Postgres database is there):

    docker-compose up -d

Create gemset using your favorite virtual environment manager (example for RVM):

    rvm use 3.2.1
    rvm gemset create bank_app
    rvm gemset use bank_app

Install dependencies:

    bundle install

You are ready for launch:

    rails s

See localhost:3000
