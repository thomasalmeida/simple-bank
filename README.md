# SIMPLE-BANK

Simple-bank is an API to banks.  Simple-bank  was created using Ruby on Rails.

## Setup
- Clone the project
- Install gems
  - `bundle install`
 - Add database configurations (database name, database username and database password) in credentials
	  - `EDITOR="nano" rails credentials:edit`
  - Create database
	  - `rails db:create && rails db:migrate`
  - Run the server
	  - `rails s`

## Routes

### Users

Add a new User

- **Endpoint:** `http://localhost:3000/signup`
- **HTTP:** POST
- **Body:** `{ "email": "user@user.com", "password": "password", "password_confimation": "password" }`


Login a new User

- **Endpoint:** `http://localhost:3000/signin`
- **HTTP:** POST
- **Body:** `{ "email": "user@user.com", "password": "password" }`

### Accounts

Add a new Account

- **Endpoint:** `http://localhost:3000/accounts`
- **HTTP:** GET
- **Header** `Authorization: Bearer $$JWT$$`

Get balance from Account

- **Endpoint:** `http://localhost:3000/accounts/balance/:id`
- **HTTP:** POST
- **Header** `Authorization: Bearer $$JWT$$`

### Transfers

Transfers credit from an acccount to other account

- **Endpoint:** `http://localhost:3000/transfer/balance/:id`
- **HTTP:** GET
- **Header** `Authorization: Bearer $$JWT$$`
- **Body:** `{ "source_id": 1, "destination_id": 2, "amount": 10.00 }`


## Usage
 Running tests:
 `rails spec`

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

This project is released under the [MIT License](https://opensource.org/licenses/MIT).
