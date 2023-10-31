import { Protocol, PMTiles} from "pmtiles"
import layers from "protomaps-themes-base"
import maplibregl from "maplibre-gl"
import mapboxgl from "mapbox-gl"

export function mapStyleLayers(mapStyle) {
  if (mapStyle.indexOf("mapbox://") === 1) return mapStyle
  const style = {
    version: 8,
    sources: {},
    layers: []
  }
  if (mapStyle.indexOf("api.protomaps.com")) {
    style.sources = {
      protomaps: {
        type: "vector",
        attribution: "Protomaps",
        url: mapStyle
      }
    }

    style.layers = layers("protomaps", "contrast")
    style.glyphs = "https://cdn.protomaps.com/fonts/pbf/{fontstack}/{range}.pbf"
  }
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