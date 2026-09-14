# Campaign Challenge API

## Requirements

- Ruby 3.3.5
- Bundler
- PostgreSQL 9.3 or newer
- Git

On macOS with Homebrew, install the runtime dependencies with:

```sh
brew install ruby@3.3 postgresql
```

Make sure the PostgreSQL service is running before creating the database:

```sh
brew services start postgresql
```

The application also includes a production Docker image. Docker users can build and run it with the commands in [Dockerfile](Dockerfile); production requires `RAILS_MASTER_KEY` and a configured database connection.

## Configuration

Install the Ruby dependencies with:

```sh
bundle install
```

Development and test databases are configured in [config/database.yml](config/database.yml) and default to the current PostgreSQL user with these names:

- `campaign_challenge_api_development`
- `campaign_challenge_api_test`

Set `DATABASE_URL` or update the relevant database configuration when PostgreSQL uses a different user, password, host, or port. The application reads `RAILS_MAX_THREADS` for the connection pool size.

The API allows `http://localhost:4200` by default for the Angular client. Set `CORS_ORIGINS` to a comma-separated list of approved origins, for example:

```sh
CORS_ORIGINS="http://localhost:4200,https://campaign.example.com"
```

Production credentials are encrypted in `config/credentials.yml.enc` and require `RAILS_MASTER_KEY`.

## Database Setup

The simplest setup is idempotent and also installs dependencies:

```sh
bin/setup --skip-server
```

To create the database and apply migrations manually:

```sh
bin/rails db:create
bin/rails db:migrate
```

Load the ten sample participants from [db/seeds.rb](db/seeds.rb) with:

```sh
bin/rails db:seed
```

To prepare the database and load seeds in one command:

```sh
bin/rails db:setup
```

## Signup API

Create a participant with `POST /api/v1/participants`:

```json
{
	"first_name": "Ava",
	"last_name": "Martinez",
	"email": "ava@example.com",
	"age": 29,
	"country_code": "US",
	"marketing_opt_in": true
}
```

Successful requests return `201 Created`:

```json
{
	"participant": {
		"id": 1,
		"first_name": "Ava",
		"last_name": "Martinez",
		"email": "ava@example.com",
		"age": 29,
		"country_code": "US",
		"marketing_opt_in": true
	},
	"message": "Signup successful"
}
```

Invalid requests return `422 Unprocessable Entity` with field-keyed message arrays:

```json
{
	"errors": {
		"email": ["is invalid"],
		"age": ["must be less than or equal to 120"]
	}
}
```

Validation rules:

- All six fields are required.
- Names are trimmed, 2-50 characters, and may contain letters, spaces, hyphens, and apostrophes.
- Emails are trimmed, normalized to lowercase, and must be unique.
- Ages must be integers from 13 through 120.
- Country codes must be two uppercase letters after normalization.
- `marketing_opt_in` must be explicitly `true` or `false`.

For local Angular development, CORS allows `http://localhost:4200` by default. Set `CORS_ORIGINS` to a comma-separated list of approved origins when needed.

## Development

Install dependencies and prepare the database:

```sh
bin/setup
```

Run the Rails test suite:

```sh
bin/rails test
```

## Development Assistance

GitHub Copilot was used to create and configure the API, create and configure the seed file, and implement the database validations.
