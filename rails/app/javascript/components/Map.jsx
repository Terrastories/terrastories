import React, { Component } from 'react';

// @NOTE: MAKE SURE ARRAY IS [LONGITUDE, LATITUDE]
const defaultCenterOfMap = [-55.63, 4.78];
const defaultBounds = [
  [-60.80409032, 0.3332811], //southwest
  [-52.41053563, 6.90258397] //northeast
]
const defaultZoom = 7.6;

export default class Map extends Component {
  constructor(props) {
    super(props);
    mapboxgl.accessToken = this.props.mapboxAccessToken;
  }

  componentDidMount() {
    this.map = new mapboxgl.Map({
      container: this.mapContainer,
      style: this.props.mapboxStyle,
      center: defaultCenterOfMap,
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
      center: defaultCenterOfMap,
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
    this.props.clearFilteredStories();
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
    });
  }

  componentDidUpdate() {
    [...document.querySelectorAll('.marker')].forEach(function(marker) {
      marker.remove();
    });

    [...document.querySelectorAll('.mapboxgl-popup')].forEach(function(popup) {
      popup.remove();
    })

    this.updateMarkers();

    if (this.props.pointCoords.length  > 0) {
      if (this.map) {
        this.map.flyTo({center: this.props.pointCoords, zoom: 14});
      }
    }
  }

  render() {
    return (
      <div ref={
        el => this.mapContainer = el
      }
      className = "ts-MainMap"/>
    );
  }
}
