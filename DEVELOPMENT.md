# Developing with Terrastories

## Table of Contents

1. [Development](#development)

2. [Importing data into Terrastories](#importing-data-into-terrastories)

3. [Adding languages to Terrastories](#adding-languages-to-terrastories)

4. [Setting up your Development Environment](#setting-up-your-development-environment)

## Development

Most developer contributions will be focused on the rails app. Because this project uses
docker, we already have a uniform ruby/rails development environment in our rails docker
image. Any time you need to run a rails command you should do so from a running docker
container to take advantage of this consistent environment. Use the following command to
open a bash console on the rails container:

```
$ docker-compose exec web /bin/bash
```

Now you can treat this console like any other development environment, running rails or
bundler commands as needed. **Please refrain from running such commands in your local
environment. Always use the rails container instead.**

Any changes to source files should be made directly in your local filesystem under the
`/opt/terrastories` directory using your preferred editing tools.

## Importing data into Terrastories

In the Terrastories back end, it is possible to import data in bulk using a CSV importer.

The data should be imported in the following order: Places, Speakers, and then Stories.

To prepare CSVs for importing, use the following workflow to ensure that character diacritics are properly imported:

-If the file is already an .xlsx, go to Google Sheets and File->Import from the menu. Then import the file.
-Otherwise create the file directly in Google Sheets. Make sure the file has a row for headers.
-Go to File -> Download As-> Comma Separated Values, and save the file to your machine.
-This CSV should be properly encoded as UTF-8. It's best to verify this with Notepad++ instead of Excel if you are on a Windows machine.

## Adding languages to Terrastories

Terrastories uses internationalization to translate the application's core text, like the welcome page, sidebar, and administrative back end content. We have made it easy to add new languages to Terrastories without needing to touch any of the code.

To add a language to Terrastories, navigate to the `rails/config/locales/` directory. Within this directory, each language has it's own subdirectory, like `en` (English) or `pt` (Portuguese). Currently, there are three files in each (using Portuguese as an example):

1.  `pt.yml`
2.  `devise.pt.yml`
3.  `administrate.pt.yml`

`pt.yml` contains the custom text used in the Terrastories application. `devise.pt.yml` and `administrative.pt.yml` are used by the administrative back end.

To set up a new language, create a new subdirectory in the `locales` folder. Let's assume you want to set up Papiamentu. Create a subdirectory called `pap` and copy over `en.yml` from the `en` folder. Rename it to `pap.yml`, change line 32 to `pap`, and translate each line of text in what follows.

For the `devise` and `administrate` files, there might be available translations already available online for common Western languages. If so, you can download these and place them in the directory, and make sure that the language code is consistent (for languages like Spanish and Portuguese, the language code might sometimes have a country-specific suffix like `pt-BR`). If translations are not available, do the same thing with these two files as translating `en.yml`.

If you want to change the default language for Terrastories, set the language on line 21 in `rails/config/application.rb`. To set it to Papiamentu, change this line to `config.i18n.default_locale = :pap`

Once you are done, the language should be available the next time you start Terrastories.


## Setting up your Development Environment

### ESLint

We use ESLint with Airbnb community style-guide for linting JavaScript and JSX for files under app/javascript.

Please check [ESLint editor-integrations page](https://eslint.org/docs/user-guide/integrations#editors) to read about how to integrate ESLint with your IDE/editor

### e2e Tests

You can run e2e tests with

```
script/test
```
