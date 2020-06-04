# Make changes to Result Links content

The find support app serves lists of links for Coronavirus Actions

Content editors can make changes to [this spreadsheet](https://docs.google.com/spreadsheets/d/11jtiwMovC9736F7ZV9k3gDbOpMMGqnSsiRmlD0JFCpQ/edit#gid=754001789) on Google Drive, and then we can import the changes into the app via a rake task.

The sheet allows for a single source of truth around content updates (which may be frequent), reduces human error on imports (compared to reading through docs and trying to copy paste changes), ensures required information is present, and helps to communicate to content editiors the status of their requested changes.

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

2. Before you run the rake task for the first time, you will need to enable to Google Drive API by generating a `credentials.json` file from the API and saving it in the root directory of the repo.  Instructions to to this can be found [here](https://developers.google.com/drive/api/v3/quickstart/ruby). It will require you to authorise using a link that appears in the CLI and copy paste a token into the CLI, which will then populate a token.yaml that will appear in the root of the repo. You will not need to do this again when running the rake task in future as long as you have `credentials.json`.

3. Run this take task:

```
bundle exec rake content:import_locale_links_from_google_sheet
```


## Updates to actions

Result links are defined in the [en.yml locale file](https://github.com/alphagov/govuk-coronavirus-find-support/blob/master/config/locales/en.yml). To import changes from the spreadsheet, you will need to run the import rake task (see below).  When the file has changed in multiple ways, only commit the changes that were requested.

```
bundle exec rake content:import_locale_links_from_google_sheet
```

You can also manually import from a provided CSV file

```
bundle exec rake content:import_locale_links[file_path]
```
