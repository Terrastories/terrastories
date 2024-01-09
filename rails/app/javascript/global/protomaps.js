import layers from "protomaps-themes-base"
import bbox from "@turf/bbox"

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

// Export mapgl for use in Rails JS. This
// allows us to add features to the map such
// as markers, popups, and navigation controls.
export async function mapgl(useMaplibre) {
  let lib
  if (useMaplibre) {
    await import('maplibre-gl').then(module => {
      lib = "Map" in module ? module : module.default
    });
  } else {
    await import('mapbox-gl').then(module => {
      lib = "Map" in module ? module : module.default
    });
  }
  return lib
}

// Instantiates a minimal Map from *-gl library
//
// Purposefully flexible since interactive maps
// in Rails have extremely varying interactions.
export function interactiveMap(lib, config) {
  const map = new lib.Map({
    ...config,
    style: mapStyleLayers(config.style),
  })
  return map
}

// Instantiates a zoomable Map from *-gl library
// with point "markers" from a feature or feature collection source
// These maps do NOT require additional gl manipulation,
// and so it loads mapgl rather than relying on it being provided.
export async function staticMap(useMaplibre, config, pointFeatures) {
  const maplib = await mapgl(useMaplibre)
  const isFeatureCollection = pointFeatures && pointFeatures.type === "FeatureCollection"

  const map = new maplib.Map({
    ...config,
    style: mapStyleLayers(config.style),
    bounds: pointFeatures !== undefined ? bbox(pointFeatures) : undefined,
    fitBoundsOptions: {
      padding: isFeatureCollection ? 50 : undefined,
      maxZoom: config.zoom || 8,
    },
    dragPan: config.allowDrag || false,
    dragRotate: false,
    pitchWithRotation: false,
    boxZoom: false,
    touchPitch: false,
    touchZoomRotate: false,
  })
  map.on("zoom", () => {
    map.setCenter(config.center)
  })
  map.on("load", () => {
    if (pointFeatures) {
      map.addSource("points", {
        "type": "geojson",
        "data": pointFeatures
      })

      map.addLayer({
        type: "circle",
        id: "circle-point",
        source: "points",
        paint: {
            "circle-color": "#09697e",
            "circle-radius": 12
        }
      })

      map.addLayer({
        type: "symbol",
        id: "points",
        source: "points",
        layout: {
          "icon-text-fit": "height",
          "icon-text-fit-padding": [1,2,1,2],
          "text-field": "{marker-symbol}",
          "text-transform": "uppercase",
          "text-font": useMaplibre ? ["Noto Sans Medium"] : ["Open Sans Bold"]
        },
        paint: {
          "text-color": "#FFFFFF"
        }
      })
    }
  })
}
