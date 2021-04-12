# Fitron Sport

The Fitron Sport Webapp is a step towards digitalization of gyms in Austrian schools.

## Tech Stack

- Ruby on Rails 6.0.3
- React + Typescript
- Stimulus.js
- Postgres SQL database
- TailwindCSS/Foundation CSS

## Configuration

There are four app environments with corresponding branches (excluding test)

1. **Production** - `master` branch
2. **Staging** - `staging` branch
3. **Development** - `develop branch.
4. **Test** - No corresponding branch.

### Testing

All testing is done using MiniTest (opposed to RSpec). Test files can be found in the `test/*` directory.

`rails test` will run all test suites.

### Staging

The staging site is protected by **HTTP Basic Authentication** to prevent unauthorized access to the site and to avoid accidental indexing by search engines.

## Deployments

The site is to be hosted [Heroku](https://www.heroku.com) with [AWS S3](https://aws.amazon.com/s3/) used for files and [SendGrid](https://sendgrid.com) for emails.

Any pushes to the `staging` branch will trigger a build & deploy to the `fitron-sport-staging` website.
