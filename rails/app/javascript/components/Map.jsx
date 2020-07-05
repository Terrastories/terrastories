import React, { Component } from "react";
import PropTypes from "prop-types";
import MiniMap from "../vendor/mapboxgl-control-minimap";

// @NOTE: MAKE SURE ARRAY IS [LONGITUDE, LATITUDE]
const defaultCenter = [-108, 38.5];
const defaultBounds = [
  [-180, -85], //southwest
  [180, 85] //northeast
];
const defaultZoom = 3.5;
const defaultPitch = 0;
const defaultBearing = 0;

export default class Map extends Component {
  constructor(props) {
    super(props);
    mapboxgl.accessToken = this.props.mapboxAccessToken;
  }

  static propTypes = {
    activePoint: PropTypes.object,
    points: PropTypes.object,
    framedView: PropTypes.object,
    onMapPointClick: PropTypes.func,
    mapboxStyle: PropTypes.string,
    mapboxAccessToken: PropTypes.string
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
      this.updateMarkers();
      this.addHomeButton();
    });

    this.map.addControl(new mapboxgl.Minimap(), "top-right");
    this.map.addControl(new mapboxgl.NavigationControl());
  }

  componentDidUpdate(prevProps) {
    // update popups
    // only display one at a time, remove all other popups
    const popupNodes = document.getElementsByClassName("mapboxgl-popup");
    Array.from(popupNodes).forEach(node => node.remove());
    if (this.props.activePoint) {
      const marker = this.props.activePoint;
      var popup = new mapboxgl.Popup({
        offset: 15,
        className: "ts-markerPopup",
        closeButton: true,
        closeOnClick: false
      })
        .setLngLat(marker.geometry.coordinates)
        .setHTML(this.buildPopupHTML(marker))
        .addTo(this.map);
      popup.on("close", () => {
        this.props.clearFilteredStories();
      });
    }
    // update points/markers
    if (this.props.points) {
      const popupNodes = document.getElementsByClassName("mapboxgl-marker");
      Array.from(popupNodes).forEach(node => node.remove());
      this.updateMarkers();
    }

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
      return;
    }
  }

  buildPopupHTML(marker) {
    if (marker.properties.photo_url) {
      if (marker.properties.region) {
        if (marker.properties.type_of_place) {
          return `<h1>${marker.properties.name}</h1>
          <div class="ts-markerPopup-content">
            <img src=${marker.properties.photo_url} />
            <div>
              <div>${I18n.t("region")}: ${marker.properties.region}</div>
              <div>${I18n.t("place_type")}: ${
            marker.properties.type_of_place
          }</div>
            </div>
          </div>`;
        } else {
          return `<h1>${marker.properties.name}</h1>
          <div class="ts-markerPopup-content">
            <img src=${marker.properties.photo_url} />
            <div>
              <div>${I18n.t("region")}: ${marker.properties.region}</div>
            </div>
          </div>`;
        }
      } else {
        return `<h1>${marker.properties.name}</h1>
          <div class="ts-markerPopup-content">
            <img src=${marker.properties.photo_url} />
          </div>`;
      }
    } else {
      if (marker.properties.region) {
        if (marker.properties.type_of_place) {
          return `<h1>${marker.properties.name}</h1>
          <div class="ts-markerPopup-content">
            <div>
              <div>${I18n.t("region")}: ${marker.properties.region}</div>
              <div>${I18n.t("place_type")}: ${
            marker.properties.type_of_place
          }</div>
            </div>
          </div>`;
        } else {
          return `<h1>${marker.properties.name}</h1>
          <div class="ts-markerPopup-content">
            <div>
              <div>${I18n.t("region")}: ${marker.properties.region}</div>
            </div>
          </div>`;
        }
      } else {
        return `<h1>${marker.properties.name}</h1>
          <div class="ts-markerPopup-content">
          </div>`;
      }
    }
  }

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

  updateMarkers() {
    this.props.points.features.forEach(marker => {
      // create a HTML element for each feature
      var el = document.createElement("div");
      el.className = "marker";
      el.id = "storypoint" + marker.id;
      // make a marker for each feature and add to the map
      new mapboxgl.Marker(el)
        .setLngLat(marker.geometry.coordinates)
        .addTo(this.map);

      el.addEventListener("click", () => {
        this.props.onMapPointClick(marker, marker.properties.stories);
        this.map.panTo(marker.geometry.coordinates);
      });
    });
  }

  render() {
    return <div ref={el => (this.mapContainer = el)} className="ts-MainMap" />;
  }
}
