import layers from "protomaps-themes-base"

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

  style.layers = layers("protomaps", theme)
  style.glyphs = "https://protomaps.github.io/basemaps-assets/fonts/{fontstack}/{range}.pbf"

  return style
}
