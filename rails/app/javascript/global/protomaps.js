import { Protocol, PMTiles} from "pmtiles"
import layers from "protomaps-themes-base"
import maplibregl from "maplibre-gl"
import mapboxgl from "mapbox-gl"

export function mapStyleLayers(mapStyle, theme = "contrast") {
  // For custom map styles from Mapbox, Tileserver, or PMtiles that
  // aren't supplied from Protomaps directly, return as-is.
  if (!mapStyle.includes("api.protomaps.com")) return mapStyle

  // Protomaps Free API
  const style = {
    version: 8,
    sources: {},
    layers: []
  }

  style.sources = {
    protomaps: {
      type: "vector",
      attribution: '<a href="https://protomaps.com">Protomaps</a> © <a href="https://openstreetmap.org">OpenStreetMap</a>',
      url: mapStyle
    }
  }

  style.layers = JSON.parse(
    JSON.stringify(layers("protomaps", theme))
      // Protomaps fonts are in flux, and until they settle or provide a
      // similar set of fonts as Open Map Tiles, replace with our standard.
      .replace(/Roboto Regular/g, "Open Sans Regular")
      .replace(/Roboto Medium/g, "Open Sans Semibold")
      .replace(/Noto Sans/g, "Open Sans")
    )
  style.glyphs = "https://fonts.openmaptiles.org/{fontstack}/{range}.pbf"

  return style
}

export function mapGL(offline, tiles) {
  if (offline) {
    if (tiles.indexOf("pmtiles")) {
      const protocol = new Protocol()
      maplibregl.addProtocol("pmtiles", protocol.tile)
      const p = new PMTiles(tiles)
      protocol.add(p)
    }
    return maplibregl
  }
  return mapboxgl
}