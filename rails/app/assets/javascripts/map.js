$(document).ready(function() {
  // @NOTE: MAKE SURE ARRAY IS [LONGITUDE, LATITUDE]
  var bounds = [
    [-60.80409032, 0.3332811], //southwest
    [-52.41053563, 6.90258397] //northeast
  ]

  var map = new mapboxgl.Map({
      container: 'map', // container id
      style: '/tiles/styles/basic/style.json',
      center: [-55.63, 4.78], // starting position [lng, lat]
      zoom: 7.6, // starting zoom
      maxBounds: bounds
  });


  var modal = document.querySelector('#modal');

  map.on('click', function(event) {
    Rails.ajax({
      url: '/point?lat=' + event.lngLat.lat + '&long=' + event.lngLat.lng,
      type: 'GET',
      success: function(_, _, xhr) {
        modal.getElementsByClassName('modal-guts')[0].innerHTML = xhr.response;
        modal.classList.toggle('closed');
      }
    });
  });

  map.on('load', function () {
    var geojson = {
      type: 'FeatureCollection',
      features: [{
        type: 'Feature',
        geometry: {
          type: 'Point',
          coordinates: [-55.370960068932845, 4.412754499901737]
        },
        properties: {
          title: 'Mapbox',
          description: 'Washington, D.C.'
        }
      },
      {
        type: 'Feature',
        geometry: {
          type: 'Point',
          coordinates: [-57.38235594732383, 4.517535458793745]
        },
        properties: {
          title: 'Mapbox',
          description: 'San Francisco, California'
        }
      }]
    };

    // add markers to map
    geojson.features.forEach(function(marker) {

      // create a HTML element for each feature
      var el = document.createElement('div');
      el.className = 'marker';

      // make a marker for each feature and add to the map
      new mapboxgl.Marker(el)
      .setLngLat(marker.geometry.coordinates)
      .addTo(map);
    });
  });

  var closeButton = document.querySelector('#close-button');

  closeButton.addEventListener('click', function() {
    modal.classList.toggle('closed');
  });
});
