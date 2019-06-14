import React, { Component } from 'react';

// @NOTE: MAKE SURE ARRAY IS [LONGITUDE, LATITUDE]
const defaultCenter = [-108, 38.5];
const defaultBounds = [
  [-180, -85], //southwest
  [180, 85] //northeast
]
const defaultZoom = 3.5;

export default class Map extends Component {
  constructor(props) {
    super(props);
    mapboxgl.accessToken = this.props.mapboxAccessToken;
  }

  componentDidMount() {
    this.map = new mapboxgl.Map({
      container: this.mapContainer,
      style: this.props.mapboxStyle,
      center: defaultCenter,
      zoom: defaultZoom,
      maxBounds: defaultBounds
    });

    this.map.on('load', () => {
      this.updateMarkers();
      this.addHomeButton();
    });

    this.map.addControl(new mapboxgl.NavigationControl());
  }

  resetMapToCenter() {
    this.map.flyTo({
      center: defaultCenter,
      zoom: defaultZoom,
      maxBounds: defaultBounds
    });
  }

  createHomeButton() {
    const homeButton = document.createElement('button');
    homeButton.setAttribute('aria-label', 'Map Home');
    homeButton.setAttribute('type', 'button');
    homeButton.setAttribute('class', 'home-icon');
    return homeButton;
  }

  addHomeButton() {
    const homeButton = this.createHomeButton();
    const navControl = document.getElementsByClassName('mapboxgl-ctrl-zoom-in')[0];
    if (navControl) {
      navControl.parentNode.insertBefore(homeButton, navControl);
    }
    homeButton.addEventListener('click', () => {
      this.resetMapToCenter();
    });
  }

  updateMarkers() {
    this.props.points.features.forEach(marker => {
      (marker.properties);
      // create a HTML element for each feature
      var el = document.createElement('div');
      el.className = 'marker';
      el.id = 'storypoint' + marker.id;
      var popup = new mapboxgl
        .Popup({ offset: 15 })
        .setHTML('<h1>' + marker.properties.title + '</h1>' + '<h2>' + marker.properties.region + '</h2>')
      // make a marker for each feature and add to the map
      new mapboxgl.Marker(el)
        .setLngLat(marker.geometry.coordinates)
        .setPopup(popup) // sets a popup on this marker
        .addTo(this.map);

      el.addEventListener('click', () => {
        this.props.onMapPointClick(marker.properties.stories);
        this.map.panTo(marker.geometry.coordinates);
      });

      popup.on('close', () => {
        this.props.clearFilteredStories();
      })
    });
  }

  componentDidUpdate() {
    [...document.querySelectorAll('.marker')].forEach(function (marker) {
      marker.remove();
    });

    [...document.querySelectorAll('.mapboxgl-popup')].forEach(function (popup) {
      popup.remove();
    })

    this.updateMarkers();

    if (this.props.pointCoords.length > 0) {
      if (this.map) {
        this.map.panTo(this.props.pointCoords);
      }
      return;
    }
  }

  render() {
    return (
      <div ref={
        el => this.mapContainer = el
      }
        className="ts-MainMap" />
    );
  }
}