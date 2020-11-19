import ReactDOM from "react-dom";
import React, { Component } from "react";
import PropTypes from "prop-types";
import MiniMap from "../vendor/mapboxgl-control-minimap";
import Popup from "./Popup";

// @NOTE: MAKE SURE ARRAY IS [LONGITUDE, LATITUDE]
const defaultCenter = [-108, 38.5];
const defaultBounds = [
  [-180, -85], //southwest
  [180, 85] //northeast
];
const defaultZoom = 3.5;
const defaultPitch = 0;
const defaultBearing = 0;
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
    useLocalMapServer: PropTypes.bool,
  };

  componentDidMount() {
    this.map = new mapboxgl.Map({
      container: this.mapContainer,
      style: this.props.mapboxStyle,
      center: defaultCenter,
      zoom: defaultZoom,
      maxBounds: defaultBounds,
      pitch: defaultPitch,
      bearing: defaultBearing
    });

    this.map.on("load", () => {
      console.log(this.props.points);
      // this.updateMarkers();
      this.addMapPoints();
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
      this.addHomeButton();
    });
    this.attachPopupsOnClick();
    if(!this.props.useLocalMapServer) {
      this.map.addControl(new mapboxgl.Minimap(), "top-right");
      this.map.addControl(new mapboxgl.NavigationControl());
    }
  }

  addMapPoints() {
    // TODO: Replace this with image asset URL passed from props
    this.map.addSource(STORY_POINTS_DATA_SOURCE, {
      type: "geojson",
      data: this.props.points
    });
    this.map.loadImage('http://placekitten.com/50/50', (error, image) => {
      if (error) throw error;
      // Add the loaded image to the style's sprite with the ID 'kitten'.
      this.map.addImage('ts-marker', image);
    });
  }

  attachPopupsOnClick() {
    this.map.on("click", STORY_POINTS_LAYER_ID, e => {
      console.log(e);
      if (e.features.length) {
        // Close currently open popup
        this.closeActivePopup();

        // Select the feature clicked on
        const feature = e.features[0];
        
        // create popup node
        const popupNode = document.createElement("div");
        ReactDOM.render(<Popup feature={feature} />, popupNode);
        // set popup on map
        const popup = new mapboxgl.Popup({
          offset: 15,
          className: "ts-markerPopup",
          closeButton: true,
          closeOnClick: false
        });
        popup.setLngLat(feature.geometry.coordinates)
        popup.setDOMContent(popupNode)
        popup.addTo(this.map);
        this.setState({
          activePopup: popup
        });
      }
    });

  }


  // componentDidUpdate(prevProps) {
  //   // update popups
  //   // only display one at a time, remove all other popups
  //   const popupNodes = document.getElementsByClassName("mapboxgl-popup");
  //   Array.from(popupNodes).forEach(node => node.remove());
  //   if (this.props.activePoint) {
  //     const marker = this.props.activePoint;
  //     var popup = new mapboxgl.Popup({
  //       offset: 15,
  //       className: "ts-markerPopup",
  //       closeButton: true,
  //       closeOnClick: false
  //     })
  //       .setLngLat(marker.geometry.coordinates)
  //       .setHTML(this.buildPopupHTML(marker))
  //       .addTo(this.map);
  //     popup.on("close", () => {
  //       this.props.clearFilteredStories();
  //     });
  //   }
  //   // update points/markers
  //   if (this.props.points) {
  //     const popupNodes = document.getElementsByClassName("mapboxgl-marker");
  //     Array.from(popupNodes).forEach(node => node.remove());
  //     this.updateMarkers();
  //   }

  //   if (
  //     this.props.framedView &&
  //     this.props.framedView !== prevProps.framedView
  //   ) {
  //     const { bounds, ...frameOptions } = this.props.framedView;
  //     if (bounds) {
  //       this.map.fitBounds(bounds, { padding: 50, duration: 2000.0, ...frameOptions });
  //     } else {
  //       this.map.easeTo({ duration: 2000.0, ...frameOptions });
  //     }
  //     return;
  //   }
  // }

  resetMapToCenter() {
    this.map.flyTo({
      center: defaultCenter,
      zoom: defaultZoom,
      pitch: defaultPitch,
      bearing: defaultBearing,
      maxBounds: defaultBounds
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

  // updateMarkers() {
  //   this.props.points.features.forEach(marker => {
  //     // create popup
  //     const popup = new mapboxgl.Popup({
  //       offset: 15,
  //       className: "ts-markerPopup",
  //       closeButton: true,
  //       closeOnClick: false
  //     }).setHTML(this.buildPopupHTML(marker));
  //     popup.on("close", () => {
  //       this.props.clearFilteredStories();
  //     });
  //     const mapboxMarker = new mapboxgl.Marker()
  //       .setLngLat(marker.geometry.coordinates)
  //       .setPopup(popup)
  //       .addTo(this.map);
  //     mapboxMarker.getElement().addEventListener('click', () => {
  //       this.props.onMapPointClick(marker, marker.properties.stories);
  //       this.map.panTo(marker.geometry.coordinates);
  //     });
  //   });
  // }

  render() {
    return <div ref={el => (this.mapContainer = el)} className="ts-MainMap" />;
  }
}
