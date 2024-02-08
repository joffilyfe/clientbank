# Customer Transactions

This project manages Bank Account's transfers.

## Dependencies

Ensure the following technologies are installed:

- Ruby 3.1.1 (with potential for upgrades)
- PostgreSQL 14.2
- Ruby on Rails 7

## Configuration

The project uses Docker for containerization and adheres to the [12-Factor App](https://12factor.net/) methodology for service-oriented applications.

Configuration relies on environment variables:

```plaintext
DATABASE_HOST=db
DATABASE_USER=user
DATABASE_PASS=pw
```

## Available routes

- `/transfers [POST]` - Receives a payload containing information about transactions to be processed.

## Setup

To prepare the application for running, execute the following commands:

```bash
# Install dependencies
bundle install

# Set up your database
bundle exec rails db:setup
```

## Running the Application

Although the project is built with Ruby on Rails. To start the application, ensure your enviroment variables are properly configured and that Sidekiq is running to handle background jobs. Then:


```bash
# if you are using your plain ruby env
bundle exec rails server

# or if you are using docker
docker-compose run web bundle exec rails db:setup

# then run its container
docker-compose up web
```

## How to test?

```bash
# Create customer with € 100 of balance
docker-compose exec -it web bundle exec rails runner "BankAccount.create(organization_name: 'nubank', bic: 'bic', iban: 'iban', balance: 100.to_money)"
```

Now you should open a new terminal and execute these following requests:

```bash

# When customer has enough money to execute operations
curl -v http://localhost:3000/transfers -H 'content-type: application/json' -d '{
    "organization_name": "nubank",
    "organization_bic": "bic",
    "organization_iban": "iban",
    "credit_transfers": [
        {
            "counterparty_name": "external_name",
            "counterparty_bic": "external_bic",
            "counterparty_iban": "external_iban",
            "amount": "10",
            "description": "desc"
        }
    ]
}'

# When customer does NOT have enough money to execute operations

curl -v http://localhost:3000/transfers -H 'content-type: application/json' -d '{
    "organization_name": "nubank",
    "organization_bic": "bic",
    "organization_iban": "iban",
    "credit_transfers": [
        {
            "counterparty_name": "external_name_one",
            "counterparty_bic": "external_bic_one",
            "counterparty_iban": "external_iban_one",
            "amount": "1",
            "description": "desc"
        },
        {
            "counterparty_name": "external_name",
            "counterparty_bic": "external_bic",
            "counterparty_iban": "external_iban",
            "amount": "100",
            "description": "desc"
        }
    ]
}'
```
