import React, { Component } from 'react';

// mapboxgl.accessToken = 'pk.eyJ1Ijoia2FsaW1hciIsImEiOiJjajdhdmNtMjkwbGZlMzJyc2RvNmhjZXd3In0.tBIY2rRDHYt1VYeGTOH98g';

export default class Map extends Component {
  constructor(props) {
    super(props);
    this.state = {
      points: []
    }
  }

  // I wonder if component will receive props is how we want to execute the flyTo
  // if new coords are received then execute the flyTo.

  componentDidMount() {
    fetch('/points.json')
      .then((response) => {return response.json()})
      .then((data) => {this.setState(({ points: data }))} )
      .catch(error => console.log(error));
    
    // @NOTE: MAKE SURE ARRAY IS [LONGITUDE, LATITUDE]
    const bounds = [
      [-60.80409032, 0.3332811], //southwest
      [-52.41053563, 6.90258397] //northeast
    ]

    this.map = new mapboxgl.Map({
      container: this.mapContainer,
      style: '/tiles/styles/basic/style.json',
      // style: 'mapbox://styles/kalimar/cjl1ia62y7ye52rn060umypfr',
      center: [-55.63, 4.78],
      zoom: 7.6,
      maxBounds: bounds
    });
    this.map.addControl(new mapboxgl.NavigationControl());
    if(this.state.points) {
      this.map.on('load', () => {
        // just testing the passing in of the coords
        this.state.points.features.forEach(marker => {
          console.log(marker.properties);
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

           el.addEventListener('click', () =>
           {
             $(".story").hide();
             $(".story." + el.id).show();
           }
         )
        });
      });
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