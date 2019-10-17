// Mapbox GL Minimap Control (https://github.com/aesqe/mapboxgl-minimap) by aesque

function Minimap ( options )
{
    Object.assign(this.options, options);

    this._ticking = false;
    this._lastMouseMoveEvent = null;
    this._parentMap = null;
    this._isDragging = false;
    this._isCursorOverFeature = false;
    this._previousPoint = [0, 0];
    this._currentPoint = [0, 0];
    this._trackingRectCoordinates = [[[], [], [], [], []]];
}

Minimap.prototype = Object.assign({}, mapboxgl.NavigationControl.prototype, {

    options: {
        id: "mapboxgl-minimap",
        width: "320px",
        height: "180px",
        style: "mapbox://styles/mapbox/light-v10",
        center: [0, 0],
        zoom: 6,

        // should be a function; will be bound to Minimap
        zoomAdjust: null,

        // if parent map zoom >= 18 and minimap zoom >= 14, set minimap zoom to 16
        zoomLevels: [
            [18, 14, 16],
            [16, 12, 14],
            [14, 10, 12],
            [12, 8, 10],
            [10, 6, 8],
            [8, 4, 6],
            [6, 2, 4],
            [3, 0, 2],
            [1, 0, 0]

        ],

        lineColor: "#136a7e",
        lineWidth: 1,
        lineOpacity: 1,

        fillColor: "#d77a34",
        fillOpacity: 0.25,

        dragPan: false,
        scrollZoom: false,
        boxZoom: false,
        dragRotate: false,
        keyboard: false,
        doubleClickZoom: false,
        touchZoomRotate: false
    },

    onAdd: function ( parentMap )
    {
        this._parentMap = parentMap;

        var opts = this.options;
        var container = this._container = this._createContainer(parentMap);
        var miniMap = this._miniMap = new mapboxgl.Map({
            attributionControl: false,
            container: container,
            style: opts.style,
            zoom: opts.zoom,
            center: opts.center
        });

        if (opts.maxBounds) miniMap.setMaxBounds(opts.maxBounds);

        miniMap.on("load", this._load.bind(this));

        return this._container;
    },

    _load: function ()
    {
        var opts = this.options;
        var parentMap = this._parentMap;
        var miniMap = this._miniMap;
        var interactions = [
            "dragPan", "scrollZoom", "boxZoom", "dragRotate",
            "keyboard", "doubleClickZoom", "touchZoomRotate"
        ];

        interactions.forEach(function(i){
            if( opts[i] !== true ) {
                miniMap[i].disable();
            }
        });

        if( typeof opts.zoomAdjust === "function" ) {
            this.options.zoomAdjust = opts.zoomAdjust.bind(this);
        } else if( opts.zoomAdjust === null ) {
            this.options.zoomAdjust = this._zoomAdjust.bind(this);
        }

        var bounds = miniMap.getBounds();

        this._convertBoundsToPoints(bounds);

        miniMap.addSource("trackingRect", {
            "type": "geojson",
            "data": {
                "type": "Feature",
                "properties": {
                    "name": "trackingRect"
                },
                "geometry": {
                    "type": "Polygon",
                    "coordinates": this._trackingRectCoordinates
                }
            }
        });

        miniMap.addLayer({
            "id": "trackingRectOutline",
            "type": "line",
            "source": "trackingRect",
            "layout": {},
            "paint": {
                "line-color": opts.lineColor,
                "line-width": opts.lineWidth,
                "line-opacity": opts.lineOpacity
            }
        });

        // needed for dragging
        miniMap.addLayer({
            "id": "trackingRectFill",
            "type": "fill",
            "source": "trackingRect",
            "layout": {},
            "paint": {
                "fill-color": opts.fillColor,
                "fill-opacity": opts.fillOpacity
            }
        });

        this._trackingRect = this._miniMap.getSource("trackingRect");

        this._update();

        parentMap.on("move", this._update.bind(this));

        miniMap.on("mousemove", this._mouseMove.bind(this));
        miniMap.on("mousedown", this._mouseDown.bind(this));
        miniMap.on("mouseup", this._mouseUp.bind(this));

        miniMap.on("touchmove", this._mouseMove.bind(this));
        miniMap.on("touchstart", this._mouseDown.bind(this));
        miniMap.on("touchend", this._mouseUp.bind(this));

        this._miniMapCanvas = miniMap.getCanvasContainer();
        this._miniMapCanvas.addEventListener("wheel", this._preventDefault);
        this._miniMapCanvas.addEventListener("mousewheel", this._preventDefault);
    },

    _mouseDown: function ( e )
    {
        if( this._isCursorOverFeature )
        {
            this._isDragging = true;
            this._previousPoint = this._currentPoint;
            this._currentPoint = [e.lngLat.lng, e.lngLat.lat];
        }
    },

    _mouseMove: function (e)
    {
        this._ticking = false;

        var miniMap = this._miniMap;
        var features = miniMap.queryRenderedFeatures(e.point, {
            layers: ["trackingRectFill"]
        });

        // don't update if we're still hovering the area
        if( ! (this._isCursorOverFeature && features.length > 0) )
        {
            this._isCursorOverFeature = features.length > 0;
            this._miniMapCanvas.style.cursor = this._isCursorOverFeature ? "move" : "";
        }

        if( this._isDragging )
        {
            this._previousPoint = this._currentPoint;
            this._currentPoint = [e.lngLat.lng, e.lngLat.lat];

            var offset = [
                this._previousPoint[0] - this._currentPoint[0],
                this._previousPoint[1] - this._currentPoint[1]
            ];

            var newBounds = this._moveTrackingRect(offset);

            this._parentMap.fitBounds(newBounds, {
                duration: 80,
                noMoveStart: true
            });
        }
    },

    _mouseUp: function ()
    {
        this._isDragging = false;
        this._ticking = false;
    },

    _moveTrackingRect: function ( offset )
    {
        var source = this._trackingRect;
        var data = source._data;
        var bounds = data.properties.bounds;

        bounds._ne.lat -= offset[1];
        bounds._ne.lng -= offset[0];
        bounds._sw.lat -= offset[1];
        bounds._sw.lng -= offset[0];

        this._convertBoundsToPoints(bounds);
        source.setData(data);

        return bounds;
    },

    _setTrackingRectBounds: function ( bounds )
    {
        var source = this._trackingRect;
        var data = source._data;

        data.properties.bounds = bounds;
        this._convertBoundsToPoints(bounds);
        source.setData(data);
    },

    _convertBoundsToPoints: function ( bounds )
    {
        var ne = bounds._ne;
        var sw = bounds._sw;
        var trc = this._trackingRectCoordinates;

        trc[0][0][0] = ne.lng;
        trc[0][0][1] = ne.lat;
        trc[0][1][0] = sw.lng;
        trc[0][1][1] = ne.lat;
        trc[0][2][0] = sw.lng;
        trc[0][2][1] = sw.lat;
        trc[0][3][0] = ne.lng;
        trc[0][3][1] = sw.lat;
        trc[0][4][0] = ne.lng;
        trc[0][4][1] = ne.lat;
    },

    _update: function ( e )
    {
        if( this._isDragging  ) {
            return;
        }

        var parentBounds = this._parentMap.getBounds();

        this._setTrackingRectBounds(parentBounds);

        if( typeof this.options.zoomAdjust === "function" ) {
            this.options.zoomAdjust();
        }
    },

    _zoomAdjust: function ()
    {
        var miniMap = this._miniMap;
        var parentMap = this._parentMap;
        var miniZoom = parseInt(miniMap.getZoom(), 10);
        var parentZoom = parseInt(parentMap.getZoom(), 10);
        var levels = this.options.zoomLevels;
        var found = false;

        levels.forEach(function(zoom)
        {
            if( ! found && parentZoom >= zoom[0] )
            {
                if( miniZoom >= zoom[1] ) {
                    miniMap.setZoom(zoom[2]);
                }

                miniMap.setCenter(parentMap.getCenter());
                found = true;
            }
        });

        if( ! found && miniZoom !== this.options.zoom )
        {
            if( typeof this.options.bounds === "object" ) {
                miniMap.fitBounds(this.options.bounds, {duration: 50});
            }

            miniMap.setZoom(this.options.zoom)
        }
    },

    _createContainer: function ( parentMap )
    {
        var opts = this.options;
        var container = document.createElement("div");

        container.className = "mapboxgl-ctrl-minimap mapboxgl-ctrl";
        var containerBorder = "border: 3px solid #136a7e";
        container.setAttribute('style', `width: ${opts.width}; height: ${opts.height}; ${containerBorder}`);
        container.addEventListener("contextmenu", this._preventDefault);

        parentMap.getContainer().appendChild(container);

        if( opts.id !== "" ) {
            container.id = opts.id;
        }

        return container;
    },

    _preventDefault: function ( e ) {
        e.preventDefault();
    }
});

mapboxgl.Minimap = Minimap;
