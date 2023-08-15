# README

# Contact Book App

Welcome to the Contact Book App! This is a simple Ruby on Rails application for managing contacts.

## Prerequisites

Before you start, make sure you have the following installed on your system:

- Ruby (>= 2.7.0)
- Ruby on Rails (>= 7.0.0)
- PostgreSQL (>= 9.3)

## Installation

1. Clone the repository:

```bash
git clone https://github.com/yourusername/contact_book.git
cd contact_book

bundle install

Set up the database:
Make sure you have PostgreSQL running. Then, create and migrate the databases for development and test environments:

rails db:create
rails db:migrate
RAILS_ENV=test rails db:create
RAILS_ENV=test rails db:migrate

Create a .env file in the project root and add your environment-specific configurations:

inside put this: CONTACT_BOOK_DATABASE_PASSWORD=yourpassword

Usage
rails server

Open your web browser and visit http://localhost:3000 to access the app.

Development Database
Open your PostgreSQL command line interface:
psql -U postgres

CREATE DATABASE contact_book_development;
CREATE USER contact_book WITH PASSWORD 'yourpassword';
ALTER ROLE contact_book SET client_encoding TO 'utf8';
ALTER ROLE contact_book SET default_transaction_isolation TO 'read committed';
ALTER ROLE contact_book SET timezone TO 'UTC';
GRANT ALL PRIVILEGES ON DATABASE contact_book_development TO contact_book;

Test Database
Create the test database and grant privileges:

CREATE DATABASE contact_book_test;
GRANT ALL PRIVILEGES ON DATABASE contact_book_test TO contact_book;
