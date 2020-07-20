# Result Links content exporter

The find support app serves lists of links for Coronavirus Actions

Content editors can view content in [this spreadsheet](https://docs.google.com/spreadsheets/d/11jtiwMovC9736F7ZV9k3gDbOpMMGqnSsiRmlD0JFCpQ/edit#gid=754001789) on Google Drive.

### Contents:

- [Set up locale developer environment](#set-up-local-developer-environment)
- [Updating result links](#updates-to-actions)

## Set up local developer environment

1. Create a `.env` file and add the sheet ID (this can be found in the URL of the Google Sheet between `/d/` and `/edit`) as an environment variable. For example:

```
# Example below is actual results sheet:
# eg. for given sheet https://docs.google.com/spreadsheets/d/11jtiwMovC9736F7ZV9k3gDbOpMMGqnSsiRmlD0JFCpQ/edit
# id="11jtiwMovC9736F7ZV9k3gDbOpMMGqnSsiRmlD0JFCpQ"
GOOGLE_SHEET_ID="a-google-sheet-id"
```

2. Before you run the rake task for the first time, you will need to enable to Google Drive API by generating a `credentials.json` file from the API and saving it in the root directory of the repo.  Instructions to to this can be found [here](https://developers.google.com/drive/api/v3/quickstart/ruby). When enabling the Drive API as part of the instructions, make sure you select 'Desktop app' from the drop down. It will require you to authorise using a link that appears in the CLI and copy paste a token into the CLI. This will then populate a token.yaml that will appear in the root of the repo. You will not need to do this again when running the rake task in future as long as you have `credentials.json`.

3. Run this take task:

```
bundle exec rake content:export_results_to_csv
```


## Updates to actions

Result links are defined in the [en.yml locale file](https://github.com/alphagov/govuk-coronavirus-find-support/blob/master/config/locales/en.yml). 

The google sheet should import results regularly, but there is a option in the sheet menu `Find Support Service -> Refresh Data` to import the data ad-hoc.

The google sheet will access the service using the url
`https://find-coronavirus-support.service.gov.uk/data-export-results-links.csv`

There is also a rake task allowing a developer to run locally without pushing the file to google. 
```
bundle exec rake content:export_results_to_csv
```
