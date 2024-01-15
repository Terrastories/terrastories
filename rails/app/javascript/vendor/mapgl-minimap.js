class Minimap {
  constructor(mapgl, config) {
    this.mapGL = mapgl
    this.parentMap = null
    this.minimap = null
    this.isDragging = false
    this.isCursorOverFeature = false
    this.currentPoint = [0, 0]
    this.previousPoint = [0, 0]
    this.trackingRectCoordinates = [[[], [], [], [], []]]

    this.options = {
      id: "mapgl-minimap",
      width: "320px",
      height: "180px",
      style: {
        version: 8,
        sources: {},
        layers: []
      },
      center: [0, 0],

      zoomLevelOffset: -4,

      lineColor: "#136a7e",
      lineWidth: 1,
      lineOpacity: 1,

      fillColor: "#d77a34",
      fillOpacity: 0.25,

      borderColor: "#136a7e",
      borderStyle: "solid",
      borderWidth: 3,

      dragPan: false,
      scrollZoom: false,
      boxZoom: false,
      dragRotate: false,
      keyboard: false,
      doubleClickZoom: false,
      touchZoomRotate: false
    }

    if (config) {
      Object.assign(this.options, config)
    }
  }

  onAdd(parentMap) {
    this.parentMap = parentMap

    const opts = this.options
    const container = this.container = this.createContainer(parentMap)

    const minimap = this.minimap = new this.mapGL.Map({
      attributionControl: false,
      container: container,
      style: opts.style,
      center: opts.center
    })

    this.zoomAdjust()

    if (opts.maxBounds) minimap.setMaxBounds(opts.maxBounds)

    minimap.getCanvas().removeAttribute("tabindex")

    this.onLoad = this.load.bind(this)
    minimap.on("load", this.onLoad)

    return this.container
  }


  onRemove() {
    this.parentMap.off("move", this.onMainMapMove)

    this.minimap.off("mousemove", this.onMouseMove)
    this.minimap.off("mousedown", this.onMouseDown)
    this.minimap.off("mouseup", this.onMouseUp)

    this.minimap.off("touchmove", this.onMouseMove)
    this.minimap.off("touchstart", this.onMouseDown)
    this.minimap.off("touchend", this.onMouseUp)

    this.minimapCanvas.removeEventListener("wheel", this.preventDefault)
    this.minimapCanvas.removeEventListener("mousewheel", this.preventDefault)

    this.container.removeEventListener("contextmenu", this.preventDefault)
    this.container.parentNode.removeChild(this.container)
    this.minimap = null
  }

  load() {
    const opts = this.options
    const parentMap = this.parentMap
    const minimap = this.minimap
    const interactions = [
      "dragPan", "scrollZoom", "boxZoom", "dragRotate",
      "keyboard", "doubleClickZoom", "touchZoomRotate"
    ]

    for(const interaction of interactions) {
      if (!opts[interaction]) {
        minimap[interaction].disable()
      }
    }

    // remove any trackingRect already loaded layers or sources
    if (minimap.getLayer('trackingRectOutline')) {
      minimap.removeLayer('trackingRectOutline');
    }

    if (minimap.getLayer('trackingRectFill')) {
      minimap.removeLayer('trackingRectFill');
    }

    if (minimap.getSource('trackingRect')) {
      minimap.removeSource('trackingRect');
    }

    // Add trackingRect sources and layers
    minimap.addSource("trackingRect", {
      "type": "geojson",
      "data": {
        "type": "Feature",
        "properties": {
          "name": "trackingRect"
        },
        "geometry": {
          "type": "Polygon",
          "coordinates": this.trackingRectCoordinates
        }
      }
    })

    minimap.addLayer({
      "id": "trackingRectOutline",
      "type": "line",
      "source": "trackingRect",
      "layout": {},
      "paint": {
        "line-color": opts.lineColor,
        "line-width": opts.lineWidth,
        "line-opacity": opts.lineOpacity
      }
    })

    // needed for dragging
    minimap.addLayer({
      "id": "trackingRectFill",
      "type": "fill",
      "source": "trackingRect",
      "layout": {},
      "paint": {
        "fill-color": opts.fillColor,
        "fill-opacity": opts.fillOpacity
      }
    })

    this.trackingRect = this.minimap.getSource("trackingRect")
    this.update()

    this.onMainMapMove = this.update.bind(this)
    this.onMainMapMoveEnd = this.parentMapMoved.bind(this)

    this.onMouseMove = this.mouseMove.bind(this)
    this.onMouseDown = this.mouseDown.bind(this)
    this.onMouseUp = this.mouseUp.bind(this)

    parentMap.on("move", this.onMainMapMove)
    parentMap.on("moveend", this.onMainMapMoveEnd)

    minimap.on("mousemove", this.onMouseMove)
    minimap.on("mousedown", this.onMouseDown)
    minimap.on("mouseup", this.onMouseUp)

    minimap.on("touchmove", this.onMouseMove)
    minimap.on("touchstart", this.onMouseDown)
    minimap.on("touchend", this.onMouseUp)

    this.minimapCanvas = minimap.getCanvasContainer()
    this.minimapCanvas.addEventListener("wheel", this.preventDefault)
    this.minimapCanvas.addEventListener("mousewheel", this.preventDefault)
  }

  mouseDown(e) {
    if (this.isCursorOverFeature) {
      this.isDragging = true
      this.previousPoint = this.currentPoint
      this.currentPoint = [e.lngLat.lng, e.lngLat.lat]
    }
  }

  mouseMove (e) {
    const minimap = this.minimap
    const features = minimap.queryRenderedFeatures(e.point, {
      layers: ["trackingRectFill"]
    })

    // don't update if we're still hovering the area
    if (!(this.isCursorOverFeature && features.length > 0)) {
      this.isCursorOverFeature = features.length > 0
      this.minimapCanvas.style.cursor = this.isCursorOverFeature ? "move" : ""
    }

    if (this.isDragging) {
      this.previousPoint = this.currentPoint
      this.currentPoint = [e.lngLat.lng, e.lngLat.lat]

      const offset = [
        this.previousPoint[0] - this.currentPoint[0],
        this.previousPoint[1] - this.currentPoint[1]
      ]

      const newBounds = this.moveTrackingRect(offset)

      this.parentMap.fitBounds(newBounds, {
        duration: 80
      })
    }
  }

  mouseUp() {
    this.isDragging = false
  }

  moveTrackingRect(offset) {
    const source = this.trackingRect
    const data = source._data
    const bounds = data.properties.bounds

    bounds._ne.lat -= offset[1]
    bounds._ne.lng -= offset[0]
    bounds._sw.lat -= offset[1]
    bounds._sw.lng -= offset[0]

    // restrict bounds to max lat/lng before setting layer data
    bounds._ne.lat = Math.min(bounds._ne.lat, 90)
    bounds._ne.lng = Math.min(bounds._ne.lng, 180)
    bounds._sw.lat = Math.max(bounds._sw.lat, -90)
    bounds._sw.lng = Math.max(bounds._sw.lng, -180)

    // convert bounds to points for trackingRect
    this.convertBoundsToPoints(bounds)

    source.setData(data)

    return bounds
  }

  setTrackingRectBounds() {
    const bounds = this.parentMap.getBounds()
    const source = this.trackingRect
    const data = source._data

    data.properties.bounds = bounds
    this.convertBoundsToPoints(bounds)
    source.setData(data)
  }

  convertBoundsToPoints(bounds) {
    const ne = bounds._ne
    const sw = bounds._sw
    const trc = this.trackingRectCoordinates

    trc[0][0][0] = ne.lng
    trc[0][0][1] = ne.lat
    trc[0][1][0] = sw.lng
    trc[0][1][1] = ne.lat
    trc[0][2][0] = sw.lng
    trc[0][2][1] = sw.lat
    trc[0][3][0] = ne.lng
    trc[0][3][1] = sw.lat
    trc[0][4][0] = ne.lng
    trc[0][4][1] = ne.lat
  }

  update() {
    if (this.isDragging) return

    this.zoomAdjust()
    this.setTrackingRectBounds()
  }

  parentMapMoved() {
    this.minimap.setCenter(this.parentMap.getCenter())
    this.zoomAdjust()
  }

  zoomAdjust() {
    this.minimap.setZoom(
      Math.max(0, this.parentMap.getZoom() + this.options.zoomLevelOffset)
    )
  }

  createContainer(parentMap) {
    const opts = this.options
    const container = document.createElement("div")

    container.className = "mapgl-minimap maplibregl-ctrl mapboxgl-ctrl"
    if (opts.containerClass) container.classList.add(opts.containerClass)
    container.setAttribute(
      "style",
      "width: " + opts.width + "; \
      height: " + opts.height + "; \
      border: " + opts.borderWidth + "px " + opts.borderStyle + " " + opts.borderColor + ";"
    )
    container.addEventListener("contextmenu", this.preventDefault)

    parentMap.getContainer().appendChild(container)

    if( opts.id !== "" ) {
      container.id = opts.id
    }

    return container
  }

  preventDefault(e) {
    e.preventDefault()
  }
}

export default Minimap