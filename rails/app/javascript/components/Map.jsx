import React, { Component } from 'react';


export default class Map extends Component {
  constructor(props) {
    super(props);
    mapboxgl.accessToken = this.props.mapboxAccessToken;
  }

  componentDidMount() {
    // @NOTE: MAKE SURE ARRAY IS [LONGITUDE, LATITUDE]
    const bounds = [
      [-60.80409032, 0.3332811], //southwest
      [-52.41053563, 6.90258397] //northeast
    ]

    this.map = new mapboxgl.Map({
      container: this.mapContainer,
      style: this.props.mapboxStyle,
      center: [-55.63, 4.78],
      zoom: 7.6,
      maxBounds: bounds
    });

    this.map.on('load', () => {
      this.updateMarkers();
      this.addHomeButton(bounds);
    });

    this.map.addControl(new mapboxgl.NavigationControl());
  }

  createHomeButton() {
    const homeButton = document.createElement('button');
    homeButton.setAttribute('aria-label', 'Map Home');
    homeButton.setAttribute('type', 'button');
    const buttonText = document.createTextNode(":)");
    homeButton.appendChild(buttonText);
    return homeButton;
  }

  addHomeButton(bounds) {
    // clear out any filtered stories
    this.props.clearFilteredStories();

    // create the home button
    const homeButton = this.createHomeButton();

    // add to nav control
    const navControl = document.getElementsByClassName('mapboxgl-ctrl-zoom-in')[0];
    if (navControl) {
      navControl.parentNode.insertBefore(homeButton, navControl);
    }

    // add event listener
    homeButton.addEventListener('click', () =>{
      this.map.fitBounds(bounds);
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
