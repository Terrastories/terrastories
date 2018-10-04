import React, { Component } from 'react';
import { featureCollection } from '@turf/helpers'


let pointSource = featureCollection([]);
export default class Map extends Component {
  constructor(props) {
    super(props);
    mapboxgl.accessToken = this.props.mapboxAccessToken;
  }

  // state = {
  //   points: this.props.points, // Used for points on map
  // }

  componentDidUpdate() {
    if (this.map) {
      if (this.props.pointCoords.length > 0) {
        this.map.flyTo({ center: this.props.pointCoords, zoom: 14 });
      }
    }
  }

  componentDidMount() {
    // @NOTE: MAKE SURE ARRAY IS [LONGITUDE, LATITUDE]
    const bounds = [
      [-60.80409032, 0.3332811], //southwest
      [-52.41053563, 6.90258397] //northeast
    ]
    // if (this.props.points) {
    //   pointSource = featureCollection(this.props.points.features);
    // }

    this.map = new mapboxgl.Map({
      container: this.mapContainer,
      style: this.props.mapboxStyle,
      center: [-55.63, 4.78],
      zoom: 7.6,
      maxBounds: bounds
    });
    this.map.addControl(new mapboxgl.NavigationControl());
    if (this.props.points) {
      this.map.on('load', () => {
        this.map.addSource("pointSource", {
          "type": "geojson",
          "data": featureCollection(this.props.points.features)
        });
        this.map.addLayer({
          "id": "storyPoints",
          "type": "circle",
          "source": "pointSource",
          "paint": {
            "circle-color": "pink",
            "circle-radius": 10
          }
        });
        // When a click event occurs on a feature in the places layer, open a popup at the
        // location of the feature, with description HTML from its properties.
        this.map.on('click', 'storyPoints', e => {
          const feature = e.features[0];
          const coordinates = feature.geometry.coordinates.slice();

          // Ensure that if the map is zoomed out such that multiple
          // copies of the feature are visible, the popup appears
          // over the copy being pointed to.
          while (Math.abs(e.lngLat.lng - coordinates[0]) > 180) {
            coordinates[0] += e.lngLat.lng > coordinates[0] ? 360 : -360;
          }

          new mapboxgl.Popup({ offset: 15 })
            .setLngLat(coordinates)
            .setHTML('<h1>' + feature.properties.title + '</h1>' + '<h2>' + feature.properties.region + '</h2>')
            .addTo(this.map);
        });

        // Change the cursor to a pointer when the mouse is over the places layer.
        this.map.on('mouseenter', 'storyPoints', () =>  {
          this.map.getCanvas().style.cursor = 'pointer';
        });

        // Change it back to a pointer when it leaves.
        this.map.on('mouseleave', 'storyPoints', () => {
          this.map.getCanvas().style.cursor = '';
        });
      });
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

      //   // just testing the passing in of the coords
      //   this.props.points.features.forEach(marker => {
      //     (marker.properties);
      //      // create a HTML element for each feature
      //      var el = document.createElement('div');
      //      el.className = 'marker';
      //      el.id = 'storypoint' + marker.id;
      //      var popup = new mapboxgl
      //        .Popup({ offset: 15 })
      //        .setHTML('<h1>' + marker.properties.title + '</h1>' + '<h2>' + marker.properties.region + '</h2>')
      //      // make a marker for each feature and add to the map
      //      new mapboxgl.Marker(el)
      //      .setLngLat(marker.geometry.coordinates)
      //      .setPopup(popup) // sets a popup on this marker
      //      .addTo(this.map);

      //      el.addEventListener('click', () =>
      //      {
      //        $(".story").hide();
      //        $(".story." + el.id).show();
      //      }
      //    )
      //   });