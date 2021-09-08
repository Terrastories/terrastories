The [Terrastories](https://www.notion.so/Terrastories-d61ccbf6dba345d1aa7f616fe4d54f6f) application uses a tileserver `TileServer-GL` developed by KlokanTech, which reads a different tile format than Mapeo: MBTiles. MBTiles is a tile format that stores tiles in a SQLite database rather than in individual folders like the tiles used by Mapeo. 

There are various pathways to convert tiles generated for Mapeo working in Terrastories.

### Converting raster tiles for Terrastories

1. Using QGIS:
    1. Load the tiles that you've generated for Mapeo into QGIS by adding the folder as a New Connection in XYZ Tiles in the Browser panel, and then add them to your map canvas.
    2. Next, use the `Generate XYZ Tiles (MBTiles)` tool to generate MBTiles. The parameters should generally stay the same, but you may want to set the Tile Format to JPG and set a minimum and maximum zoom level.
2. Using TL:
    1. In a terminal, navigate to the directory where your tiles are located, and run a conversion command like `tl copy -z 1 -Z 16 file://./**tile-directory** mbtiles://./**tiles**.mbtiles` where **tile-directory** is the name of the directory, and **tiles** is the name you want to give your mbtiles file.

Either pathway will generate a raster `.mbtiles` file which you can add to Terrastories in the `/tileserver/data/mbtiles` directory, and then define in `style.json` (more on that in the Terrastories documentation [here](https://github.com/Terrastories/terrastories/blob/master/documentation/SETUP-OFFLINE.md#setting-up-offline-environment-and-map)).

### Converting vector tiles for Terrastories

1. Converting the tiles to MBTiles
    1. Using TL:
        1. In a terminal, navigate to the directory where your tiles are located, and run a conversion command like `tl copy -z 1 -Z 16 file://./**tile-directory** mbtiles://./**tiles**.mbtiles` where **tile-directory** is the name of the directory, and **tiles** is the name you want to give your mbtiles file.
2. Editing the style.json
    1. In the `style.json` file that comes with the tiles generated for Mapeo, replace the `sources` → `composite` content with the following: 

    ```jsx
    "composite": {
    "url": "mbtiles://mbtiles/tiles.mbtiles",
    "type": "vector"
    }
    ```

    In addition, change the sprites and glyphs definitions to the following:

    ```jsx
    "sprite": "sprite",
    "glyphs": "{fontstack}/{range}.pbf",
    ```

3. Place the MBTiles, style.json, sprites, and font glyphs in the Terrastories tileserver directory, and adapt `config.json`. 
    1. There are dedicated folders for the `MBTiles`, sprites, and glyphs.
    2. In `config.json`, set the `"mbtiles":` definition to your MBTiles file. 

With all of this done, the next time you start Terrastories for offline mode it should load the vector tiles successfully as the basemap. (You can also check the tileserver directly by visiting `localhost:8080`.
