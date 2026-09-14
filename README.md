# Campaign Challenge API

Rails API for participant signup, score submission, and leaderboard results. The API is designed to run alongside the companion Angular application in the `campaign-challenge-web` repository.

## Contents

- [Requirements](#requirements)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
- [Database Setup](#database-setup)
- [API](#api)
  - [Signup](#signup)
  - [Scores](#scores)
  - [Leaderboard](#leaderboard)
- [Development](#development)
- [Development Assistance](#development-assistance)

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

## Quick Start

Install dependencies, create the databases, and start the API:

```sh
bin/setup
bin/rails server -p 3000
```

The API is then available at `http://localhost:3000`. To load the sample participants, run:

```sh
bin/rails db:seed
```

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

## API

### Signup

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

### Scores

After signup, submit the participant's final game score with `POST /api/v1/participants/:participant_id/scores`:

```json
{
  "score": 3,
  "duration_ms": 45210
}
```

The participant must exist, must have been created within the previous 24 hours, and may submit only one score. `score` and `duration_ms` must be positive integers. `played_at` is assigned by the server and cannot be supplied by the client.

Successful requests return `201 Created`:

```json
{
  "score": {
    "id": 1,
    "participant_id": 1,
    "score": 3,
    "duration_ms": 45210,
    "played_at": "2026-09-14T12:00:00.000Z"
  }
}
```

Invalid, expired, missing, or duplicate submissions return `422 Unprocessable Entity` with the same field-keyed error format used by signup.

### Leaderboard

Fetch the top ten scores with `GET /api/v1/leaderboard`:

```json
{
  "leaderboard": [
    {
      "score": 12,
      "first_name": "Ava",
      "played_at": "2026-09-14T12:00:00.000Z"
    }
  ]
}
```

Results are ordered by score from highest to lowest and include the participant's first name and play date.

## Development

This repository provides the Rails API. The participant signup experience is completed by running it alongside the companion Angular application in the `campaign-challenge-web` repository. Keep both repositories as sibling directories:

```text
Code/
├── campaign-challenge-api/
└── campaign-challenge-web/
```

### Start the Rails API

From this repository, install dependencies and prepare the database once:

```sh
bin/setup
```

Start Rails in one terminal:

```sh
bin/rails server -p 3000
```

The API is available at `http://localhost:3000`.

### Start the Angular application

In a second terminal, install the web application's dependencies and start Angular:

```sh
cd ../campaign-challenge-web
npm install
npm start
```

Open `http://localhost:4200/` in a browser. The Angular development server proxies `/api/*` requests to the Rails API on port `3000`, and Rails allows `http://localhost:4200` through CORS by default.

Run both servers during local development. Changes to Rails code are picked up by the Rails server, and changes to Angular code are picked up by the Angular development server.

Run the Rails test suite:

```sh
bin/rails test
```

## Development Assistance

GitHub Copilot was used to create and configure the API, create and configure the seed file, and implement the database validations.

## Improvements
If I had another day to work on this, the first thing I'd do is reorganize and rewrite the README file. It's a bit convoluted and could do with some better formatting.

The next thing would be to add some support for other languages, probably via the i18n gem. A marketing campaign, especially one focused on Europe, would benefit from including at least a few languges other than english.

The last thing I can think of is that I'd make the country code a selector instead, since I'm sure not everyone knows what's expected from that field. A selector would probably be more user-friendly.
