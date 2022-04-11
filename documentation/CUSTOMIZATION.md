1. [Setting up a custom map](#setting-up-a-custom-map)

2. [Adding languages to Terrastories](#adding-languages-to-terrastories)

3. [Adding custom visual assets](#adding-custom-visual-assets)

4. [Importing data into Terrastories](#importing-data-into-terrastories)

*Note: all of these customization possibilities were also covered in a series of self-guided tutorials and accompanying videos for the 2020 Indigenous Mapping Workshop. The links to those can be found on the [Terrastories website](https://terrastories.io/tutorials/).*

## Setting up a custom map

### Map content

Terrastories uses the Mapbox GL JS library to serve maps. Terrastories can either load maps from `Mapbox.com` directly, or load offline map tiles in the `MBTiles` format together with font glyphs, image sprites, and a `style.json` file.

For some online use cases, it may be sufficient to use one of Mapbox's basic styles, such as OpenStreetMap (OSM) or imagery. The default map served by Terrastories is a light OSM map. 

You may also opt to design your own custom map style using Mapbox Studio. You could either customize one of these basic styles, or if you have your own GIS data, you can upload the data to [Mapbox Studio](https://www.mapbox.com/mapbox-studio/), and use the Studio interface to lay out the map. You have to have a Mapbox account to use Mapbox Studio (creating and designing maps using Mapbox Studio is free up to certain file size limitations). To learn how to use Mapbox Studio, you can refer to the manuals and tutorials made available by Mapbox [here](https://www.mapbox.com/help/studio-manual-tutorials/) or other resources on the web.

For online use of Terrastories, you can set a `Mapbox.com` map for a community in the `Theme` menu when logged in as an admin user. Paste in the map style URL, and your map token, in the respective fields and it will automatically update the map for that community instance.

For offline "Field Kit" usage of Terrastories, you need to supply your own map tiles (in `MBTiles` format). There are several additional steps to generate and style the `MBTiles`, described in the [SETUP-OFFLINE.md](SETUP-OFFLINE.md) file. It's also possible to get offline basemaps for [Mapeo](https://mapeo.app) working in Terrastories: please see our [Mapeo to Terrastories guide](MAPEO-MAPS-IN-TERRASTORIES.md).

_**Note:** when using Mapbox.com maps with Terrastories, you are subject to Mapbox's [pricing schema](https://www.mapbox.com/pricing/) which has a free tier of up to 50,000 map loads per month. If you anticipate more monthly loads than that, you can get in touch with Mapbox's community team at community@mapbox.com to see what they can do to help._

### Map extent and zoom

It is possible to set a custom map extent, zoom level, and boundaries of the Terrastories map. This can be done in the Terrastories `Theme` menu for a community when logged in as a user with admin permissions.
## Adding languages to Terrastories

Terrastories uses internationalization to translate the application's core text, like the welcome page, sidebar, and administrative back end content. We have made it easy to add new languages to Terrastories without needing to touch any of the code. However, please note that this will only work for Terrastories that you host yourself (online or offline). In the future, we will make it possible to easily add other languages per each community on a Terrastories server.

To add a language to Terrastories, navigate to the `rails/config/locales/` directory. Within this directory, each language has it's own subdirectory, like `en` (English) or `pt` (Portuguese). Currently, there are three files in each (using Portuguese as an example):

1.  `pt.yml`
2.  `devise.pt.yml`
3.  `administrate.pt.yml`

`pt.yml` contains the custom text used in the Terrastories application. `devise.pt.yml` and `administrative.pt.yml` are used by the administrative back end.

To set up a new language, create a new subdirectory in the `locales` folder. Let's assume you want to set up Papiamentu. Create a subdirectory called `pap` and copy over `en.yml` from the `en` folder. Rename it to `pap.yml`, change line 32 to `pap`, and translate each line of text in what follows.

For the `devise` and `administrate` files, there might be available translations already available online for common Western languages. If so, you can download these and place them in the directory, and make sure that the language code is consistent (for languages like Spanish and Portuguese, the language code might sometimes have a country-specific suffix like `pt-BR`). If translations are not available, do the same thing with these two files as translating `en.yml`.

If you want to change the default language for Terrastories, set the language on line 21 in `rails/config/application.rb`. To set it to Papiamentu, change this line to `config.i18n.default_locale = :pap`

Once you are done, the language should be available the next time you start Terrastories. 

## Adding custom visual assets

You can add your own background image for the Welcome screen of Terrastories, and any logos you want to appear under the login box on the Welcome screen. These can be added via the `Theme` menu when logged in as an admin user.

## Importing data into Terrastories

In the Terrastories administrative back end, it is possible to import data in bulk using a CSV importer. This can be useful for projects where a lot of stories and data has been processed in advance, and can be added all at once instead of being entered one-by-one.

### Step 1: Prepare the CSVs

First, download [this Terrastories data structure template](https://drive.google.com/file/d/1Ir6TC5THEoQKk-98JZ5KpTjXd-R6yMmA/view?usp=sharing) which has three different tabs, for Places, Speakers, and Stories. The idea is to populate the spreadsheet with your data, and to then save each tab in a CSV format (`Places.csv`, `Speakers,csv`, and `Stories.csv`).

Note the sample data, and the order of the columns in the spreadsheet. For the CSV importer to work, you have to stick with the same column order. 

When imported, there will be links between different data types. To create these links, the content in the following fields has to match exactly:
* The entries for `speaker_name` in the `Speakers` tab have to be the same as the entries for `speaker_name` in the `Stories` tab.
* The entries for `place_name` in the `Places (Points)` tab have to be the same as the entries for `place_name` in the `Stories` tab.
* For the media attachments in the `Photo (file upload)` field in `Speakers` and `Places (Points)` and in the `Video (file upload)` field in `Stories`, you have to put the exact filenames with case-sensitive writing (including in the extension like `png`, `jpg`, `JPG`, etc.) or the file will not import. 

For languages with diacritics (like accents or unusual characters), to prepare CSVs for importing use the following workflow to ensure that character diacritics are properly imported:

-If the file is already an .xlsx, go to Google Sheets online and select File->Import from the menu. Then import the .xlsx file.
-Otherwise create the file directly in Google Sheets. Make sure the file has a row for headers.
-Go to File -> Download As-> Comma Separated Values, and save the file to your machine.
-This CSV should be properly encoded as UTF-8. It's best to verify this with Notepad++ instead of Excel if you are on a Windows machine.

### Step 2: Place your media imports in the right folder

When you are done preparing your CSV spreadsheets and the media (photo, video) attachments, place all of these files in the `data/import/media` directory. Do not create subfolders in this directory -- place all the files directly in this folder.

### Step 3: Import CSVs and media attachments into Terrastories

Third, using the Administrative back end in Terrastories, use the import button at the bottom of the page and upload the CSV. The data should be imported in the following order: `Places`, `Speakers`, and then `Stories`.

If you are uploading large media files (like videos), it may take a while for the spreadsheets to be processed. Do not navigate away from the page during this time.

If the data and media attachment upload is successful, you should see all of the rows in your spreadsheet in Terrastories, and any media attachments that are associated with the data. If the media did not upload successfully, ensure that the media filenames in the CSV matches the actual files.

Once the files have been uploaded to Terrastories, you can remove the files in `/data/import/media` if desired (i.e. to clear up space).
