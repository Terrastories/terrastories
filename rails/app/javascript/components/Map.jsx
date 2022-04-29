import ReactDOM from "react-dom";
import React, { Component } from "react";
import PropTypes from "prop-types";
import MiniMap from "../vendor/mapboxgl-control-minimap";
import Popup from "./Popup";

const STORY_POINTS_LAYER_ID = "ts-points-layer";
const STORY_POINTS_DATA_SOURCE = "ts-points-data";

export default class Map extends Component {
  constructor(props) {
    super(props);
    mapboxgl.accessToken = this.props.mapboxAccessToken;
    this.state = {
      activePopup: null
    };
  }

  static propTypes = {
    activePoint: PropTypes.object,
    points: PropTypes.object,
    framedView: PropTypes.object,
    onMapPointClick: PropTypes.func,
    mapboxStyle: PropTypes.string,
    mapboxAccessToken: PropTypes.string,
    mapbox3d: PropTypes.bool,
    useLocalMapServer: PropTypes.bool,
    markerImgUrl: PropTypes.string,
  };

  componentDidMount() {
    this.map = new mapboxgl.Map({
      container: this.mapContainer,
      style: this.props.mapboxStyle,
      center: [this.props.centerLong, this.props.centerLat],
      zoom: this.props.zoom,
      maxBounds: this.checkBounds(), // check for bounding box presence
      pitch: this.props.pitch,
      bearing: this.props.bearing
    });

    this.map.on("load", () => {

      // Add map point data to the map
      this.addMapPoints();

      // Add mapbox markers to the map
      this.map.addLayer({
        id: STORY_POINTS_LAYER_ID,
        source: STORY_POINTS_DATA_SOURCE,
        type: "symbol",
        layout: {
          "icon-image": "ts-marker",
          "icon-padding": 0,
          "icon-allow-overlap": true
        }
      });


      // Add 3d terrain DEM layer if activated
      if(!this.props.useLocalMapServer && this.props.mapbox3d) {
        this.map.addSource('mapbox-dem', {
          'type': 'raster-dem',
          'url': 'mapbox://mapbox.mapbox-terrain-dem-v1',
          'tileSize': 512,
          'maxzoom': 14
        });

        // add the DEM source as a terrain layer with exaggerated height
        this.map.setTerrain({ 'source': 'mapbox-dem', 'exaggeration': 1.5 });

        // add a sky layer that will show when the map is highly pitched
        this.map.addLayer({
          'id': 'sky',
          'type': 'sky',
          'paint': {
          'sky-type': 'atmosphere',
          'sky-atmosphere-sun': [0.0, 0.0],
          'sky-atmosphere-sun-intensity': 15
          }
        });
      }

      this.addHomeButton();

      // Attaches popups + events
      this.addMarkerClickHandler();
    });

        // Hide minimap for offline Terrastories
    if(!this.props.useLocalMapServer) {
      this.map.addControl(new mapboxgl.Minimap(), "top-right");
    }

    this.map.addControl(new mapboxgl.NavigationControl());
        // Change mouse pointer when hovering over ts-marker points
        this.map.on('mouseenter', STORY_POINTS_LAYER_ID, () => {
          this.map.getCanvas().style.cursor = 'pointer'
        })
        this.map.on('mouseleave', STORY_POINTS_LAYER_ID, () => {
          this.map.getCanvas().style.cursor = ''
    })
  }

  componentDidUpdate(prevProps, prevState) {
    if (prevProps.points !== this.props.points) {
      this.updateMapPoints();
    }

    if (prevProps.activePoint && !this.props.activePoint) {
      this.closeActivePopup();
    }

    // Open active popup
    if (this.props.activePoint && prevProps.activePoint !== this.props.activePoint) {
      this.openPopup(this.props.activePoint);
    }

    // Set map framed view
    if (
      this.props.framedView &&
      this.props.framedView !== prevProps.framedView
    ) {
      const { bounds, ...frameOptions } = this.props.framedView;
      if (bounds) {
        this.map.fitBounds(bounds, { padding: 50, duration: 2000.0, ...frameOptions });
      } else {
        this.map.easeTo({ duration: 2000.0, ...frameOptions });
      }
    }
  }

  addMapPoints() {
    this.map.addSource(STORY_POINTS_DATA_SOURCE, {
      type: "geojson",
      data: this.props.points
    });
    this.map.loadImage(this.props.markerImgUrl, (error, image) => {
      if (error) throw "Error loading marker images: " + error;
      this.map.addImage('ts-marker', image);
    });
  }

  updateMapPoints() {
    if (this.map.getSource(STORY_POINTS_DATA_SOURCE)) {
      this.map.getSource(STORY_POINTS_DATA_SOURCE).setData(this.props.points);
    }
  }

  addMarkerClickHandler() {
    this.map.on("click", STORY_POINTS_LAYER_ID, e => {
      if (e.features.length) {
        // Select the feature clicked on
        const feature = e.features[0];
        this.openPopup(feature);
        this.props.onMapPointClick(feature);
      }
    });
  }

  openPopup(feature) {
    // Only show one popup at a time, close the active
    this.closeActivePopup();
    // create popup node
    const popupNode = document.createElement("div");
    ReactDOM.render(<Popup feature={feature} onCloseClick={() => {
      this.props.clearFilteredStories();
      this.closeActivePopup();
    }} />, popupNode);
    // set popup on map
    const popup = new mapboxgl.Popup({
      offset: 15,
      className: "ts-markerPopup",
      closeButton: false, // We add our own custom close button
      closeOnClick: false
    });
    popup.setLngLat(feature.geometry.coordinates)
    popup.setDOMContent(popupNode)
    popup.addTo(this.map);
    // Set active popup in state
    this.setState({
      activePopup: popup
    });
  }

  resetMapToCenter() {
    this.map.flyTo({
      center: [this.props.centerLong, this.props.centerLat],
      zoom: this.props.zoom,
      pitch: this.props.pitch,
      bearing: this.props.bearing,
      maxBounds: this.checkBounds(), // check for bounding box presence
    });
  }

  // TODO: update this to JSX
  createHomeButton() {
    const homeButton = document.createElement("button");
    homeButton.setAttribute("aria-label", "Map Home");
    homeButton.setAttribute("type", "button");
    homeButton.setAttribute("class", "home-icon");
    return homeButton;
  }

  addHomeButton() {
    const homeButton = this.createHomeButton();
    const navControl = document.getElementsByClassName(
      "mapboxgl-ctrl-zoom-in"
    )[0];
    if (navControl) {
      navControl.parentNode.insertBefore(homeButton, navControl);
    }
    homeButton.addEventListener("click", () => {
      this.resetMapToCenter();
    });
  }

  closeActivePopup() {
    if (this.state.activePopup) {
      this.state.activePopup.remove();
    }
  }

  render() {
    return <div ref={el => (this.mapContainer = el)} className="ts-MainMap" />;
  }

  // test for bounding box presence
  checkBounds() {
    let mapBounds = null;
    if (this.props.sw_boundary_long != null && this.props.sw_boundary_lat != null 
    && this.props.ne_boundary_long != null && this.props.ne_boundary_lat != null) {
        mapBounds = [
            [this.props.sw_boundary_long, this.props.sw_boundary_lat], //southwest
            [this.props.ne_boundary_long, this.props.ne_boundary_lat] //northeast
        ]
    }
    return mapBounds;
  }
}