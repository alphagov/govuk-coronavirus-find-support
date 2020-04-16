# GOV.UK coronavirus - find support

![Run tests](https://github.com/alphagov/govuk-coronavirus-find-support/workflows/Run%20tests/badge.svg)

Helps people in the UK find relevant support during the Covid-19 pandemic.

## Getting started

The instructions will help you to get the application running
locally on your machine.

### Prequisites

You will need Postgres installed in order for bundler to install the `pg` gem (and `libpq-dev` if on Linux).  

You'll need a JavaScript runtime: https://github.com/rails/execjs  
Clone the app and run `bundle` locally.  

### Running Postgres

#### Locally

    brew install postgres
    postgres -D /usr/local/var/postgres

Then set up your local database

    rails db:setup

#### Docker

    docker pull postgres
    docker run -d -e POSTGRES_PASSWORD=password -e POSTGRES_USER=user -e POSTGRES_DB=coronavirus_form_development -p 5432:5432 postgres

Then set up your Docker database

    DATABASE_URL="postgres://user:password@localhost:5432/coronavirus_find_support_form_development" rails db:setup

You'll then need to specify the `DATABASE_URL` environment variable before the below tasks.

### Running the application (Postgres will need to be running)

    foreman start

### Running the tests

    bundle exec rake


## Deployment pipeline

Every commit to master is deployed to GOV.UK PaaS by
[this concourse pipeline](https://cd.gds-reliability.engineering/teams/govuk-tools/pipelines/govuk-corona-find-support),
which is configured in [concourse/pipeline.yml](concourse/pipeline.yml).

The concourse pipeline has credentials for the `govuk-forms-deployer` user in
GOV.UK PaaS. This user has the SpaceDeveloper role, so it can `cf push` the application.

## Exporting form response data

Aggregated anonymous daily data can be extracted from the application for any
specified time period using the `/data-export` route.  Output is available in
CSV format.

For example, to get data for a five day period starting 10th April 2020:

     <path-to-service>/data-export.csv?start_date=2020-04-08&end_date=2020-04-15
