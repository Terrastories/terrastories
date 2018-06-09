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
  map.on('load', function () {
    Rails.ajax({
      url: '/points',
      type: 'GET',
      dataType: 'json',
      success: function(response) {
        response.features.forEach(function(marker) {
          console.log(marker.properties);
          // create a HTML element for each feature
          var el = document.createElement('div');
          el.className = 'marker';
          var popup = new mapboxgl
            .Popup({ offset: 15 })
            .setHTML('<h1>' + marker.properties.title + '</h1>' + '<h2>' + marker.properties.region + '</h2>')
          // make a marker for each feature and add to the map
          new mapboxgl.Marker(el)
          .setLngLat(marker.geometry.coordinates)
          .setPopup(popup) // sets a popup on this marker
          .addTo(map);
        });
      }
    });
  });
});
