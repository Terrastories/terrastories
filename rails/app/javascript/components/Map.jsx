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
    mapProjection: PropTypes.string,
    useLocalMapServer: PropTypes.bool,
    markerImgUrl: PropTypes.string,
    markerClusterImgUrl: PropTypes.string,
  };

  componentDidMount() {
    this.map = new mapboxgl.Map({
        container: this.mapContainer,
        style: this.props.mapboxStyle,
        center: [this.props.centerLong, this.props.centerLat],
        zoom: this.props.zoom,
        maxBounds: this.checkBounds(), // check for bounding box presence
        pitch: this.props.pitch,
        bearing: this.props.bearing,
        projection: this.props.mapProjection
    });

    this.map.on("load", () => {

      // Add map point data to the map
      this.addMapPoints();

      // Add mapbox markers to the map
      this.map.addLayer({
        id: STORY_POINTS_LAYER_ID,
        source: STORY_POINTS_DATA_SOURCE,
        filter: ['!', ['has', 'point_count']], // single point, non-cluster
        type: "symbol",
        layout: {
          "icon-image": "ts-marker",
          "icon-padding": 0,
          "icon-allow-overlap": true,
          "icon-size": 0.75
        }
      });

      // Add clusters for overlapping markers
      this.map.addLayer({
        id: 'clusters',
        source: STORY_POINTS_DATA_SOURCE,
        filter: ['has', 'point_count'], // multiple points, cluster
        type: "symbol",
        layout: {
          "icon-image": "ts-marker-cluster",
          "icon-padding": 0,
          "icon-allow-overlap": true,
          "icon-size": [ // make cluster size reflect number of points within
              "interpolate",
              ["linear"],
              ['get', 'point_count'],
              // when number of points in cluster is 2, size will be 0.7 * single point
              2,
              0.7,
              // when number of points in cluster is 10 or more, size will be 0.8 * single point
              10,
              0.8
          ]
        }
      });

      // Add labels for number of points clustered for overlapping markers
      this.map.addLayer({
        id: 'clustercount',
        source: STORY_POINTS_DATA_SOURCE,
        filter: ['has', 'point_count'], // multiple points, cluster
        type: "symbol",
        layout: {
          'text-field': '{point_count_abbreviated}',
          'text-font': ['Open Sans Bold'],
          'text-size': 16,
          'text-offset': [0.2, 0.1]
          },
        paint: {
          'text-color': "#ffffff",
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
    
        // add the DEM source
        this.map.setTerrain({ 'source': 'mapbox-dem' });
          
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

      // Add custom nav control components
      this.addHomeButton();
      this.addCompassButton();

      // Attaches popups + events
      this.addMarkerClickHandler();

      // Click handler for clusters, zoom in when clicked
      this.addClusterClickHandler();
    });

    // Hide minimap and nav controls for offline Terrastories
    if(!this.props.useLocalMapServer) {
      this.map.addControl(new mapboxgl.Minimap(), "top-right");
    }

    this.map.addControl(new mapboxgl.NavigationControl({
      //showCompass: false
    }));

    // Add rotate behavior for custom compass
    this.map.on('rotate', () => {
      const map = this.map;
      const rotate = this.navControl ?
          `scale(${1 / Math.pow(Math.cos(map.transform.pitch * (Math.PI / 180)), 0.5)}) rotateX(${map.transform.pitch}deg) rotateZ(${map.transform.angle * (180 / Math.PI)}deg)` :
          `rotate(${map.transform.angle * (180 / Math.PI)}deg)`;
      document.getElementsByClassName("mapboxgl-ctrl-compass")[0].firstChild.style.transform = rotate;
    });

    // Change mouse pointer when hovering over ts-marker points
    this.map.on('mouseenter', STORY_POINTS_LAYER_ID, () => {
      this.map.getCanvas().style.cursor = 'pointer'
    })
    this.map.on('mouseleave', STORY_POINTS_LAYER_ID, () => {
      this.map.getCanvas().style.cursor = ''
    })

    // Change mouse pointer when hovering over ts-marker-cluster points
    this.map.on('mouseenter', 'clusters', () => {
      this.map.getCanvas().style.cursor = 'pointer'
    })
    this.map.on('mouseleave', 'clusters', () => {
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
      data: this.props.points,
      cluster: true, // turn clustering on
      clusterMaxZoom: 14, // max zoom on which to cluster points, default is 14
      clusterRadius: 50 // radius of each cluster when clustering points, default is 50
    });
    // default Terrastories marker icon
    this.map.loadImage(this.props.markerImgUrl, (error, image) => {
      if (error) throw "Error loading marker images: " + error;
      this.map.addImage('ts-marker', image);
    });
    // default Terrastories cluster icon; in the future we will need to think of way to visualize clusters of user-submitted custom icons
    this.map.loadImage(this.props.markerClusterImgUrl, (error, image) => {
      if (error) throw "Error loading marker images: " + error;
      this.map.addImage('ts-marker-cluster', image);
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

  addClusterClickHandler() {
    // Inspect a cluster (zoom in) on click
    this.map.on("click", "clusters", e => {
      const features = this.map.queryRenderedFeatures(e.point, {
        layers: ["clusters"]
      });
      const clusterId = features[0].properties.cluster_id;
      this.map.getSource(STORY_POINTS_DATA_SOURCE).getClusterExpansionZoom(
          clusterId,
          (err, zoom) => {
            if (err) return;

            this.map.easeTo({
              center: features[0].geometry.coordinates,
              zoom: zoom
            });
          }
      );
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

  // TODO: update this to JSX
  createCompassButton() {
    const compassButton = document.createElement("button");
    compassButton.setAttribute("class", "mapboxgl-ctrl-compass");
    compassButton.setAttribute("type", "button");
    compassButton.setAttribute("aria-label", "Reset bearing");
    const compassIcon = document.createElement("span");
    compassIcon.setAttribute("class", "mapboxgl-ctrl-icon");
    compassIcon.setAttribute("aria-hidden", "true");
    compassButton.appendChild(compassIcon);
    return compassButton;
  }

  addCompassButton() {
    const compassButton = this.createCompassButton();
    const navControl = document.getElementsByClassName(
      "mapboxgl-ctrl-zoom-out"
    )[0];
    const compass = document.getElementsByClassName(
      "mapboxgl-ctrl-compass"
    )[0];
    if (navControl) {
      navControl.parentNode.insertBefore(compassButton, navControl.nextSibling);
    }

    let userBearing = 0
    compassButton.addEventListener("click", () => {
      if (this.map.getBearing() != 0) {
          userBearing = this.map.getBearing();
          this.map.resetNorth({duration: 1000});
      } else {
          this.map.rotateTo(userBearing, {duration: 1000});
      }
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