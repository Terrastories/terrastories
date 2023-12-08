import ReactDOM from "react-dom";
import React, { Component } from "react";
import PropTypes from "prop-types";
import Popup from "./Popup";

import '../vendor/d3-celestial/d3.min.js';
import '../vendor/d3-celestial/d3.geo.projection.min.js';
import '../vendor/d3-celestial/celestial.min.js';
import '../vendor/d3-celestial/celestial.css';

const STORY_POINTS_LAYER_ID = "ts-points-layer";
const STORY_POINTS_DATA_SOURCE = "ts-points-data";

export default class CelestialMap extends Component {
  constructor(props) {
      super(props);
      this.state = {
        activePopup: null,
        centerLong: null,
        centerLat: null
      };
  }

  static propTypes = {
    activePoint: PropTypes.object,
    points: PropTypes.object,
    framedView: PropTypes.object,
  };

  componentDidMount() { 
    const centerLong = parseInt(this.props.centerLong);
    const centerLat = parseInt(this.props.centerLat);

    var config = { 
        projection: "airy", 
        zoomlevel: this.props.zoom,
        center: [centerLong, centerLat],
        follow: "center",
        background: { fill: "#333", stroke: "#b3b300", opacity: 1, width: 4 },
        container: "celestial-map", 
        datapath: "../d3-celestial/data/",
        
        culture: "cn",
        constellations: {
          show: true,    //Show constellations 
          names: true,   //Show constellation names 
          namesType: "cn",
          nameStyle: { fill: ["#fec", "#f6c", "#fec"], opacity:0.9, font: ["bold 14px 'Lucida Sans Unicode', Trebuchet, Helvetica, Arial, sans-serif", "18px 'Lucida Sans Unicode', Trebuchet, Helvetica, Arial, sans-serif", "14px 'Lucida Sans Unicode', Trebuchet, Helvetica, Arial, sans-serif"], align: "center", baseline: "middle" },
          lines: true,   //Show constellation lines 
          lineStyle: { stroke: ["#99c", "#f6c", "#99c"], width: [2, 2.5, 2], opacity: 0.75 },
          bounds: true,  //Show constellation boundaries 
          boundStyle: { stroke: "#ffff00", width: 1.0, opacity: 0.7, dash: [8, 4, 2, 4] }
        },
        stars: { 
          limit: 5,
          propername: true,
          propernameStyle: { fill: "#9999bb", font: "13px 'Palatino Linotype', Georgia, Times, 'Times Roman', serif", align: "right", baseline: "bottom" },
          propernameLimit: 2.5,
          designation: false,
          designationStyle: { fill: "#9999bb", font: "11px 'Palatino Linotype', Georgia, Times, 'Times Roman', serif", align: "left", baseline: "top" },
          designationLimit: 2.5,
        },
        dsos: { 
          show: false
        },
        mw: { 
          style: { fill:"#ffffff", opacity: 0.1 } 
        },
        planets: {  //Show planet locations
          show: true
        }
    };
      
    Celestial.display(config); 

    this.setState({
      centerLong: centerLong,
      centerLat: centerLat
    })
  }

  componentDidUpdate(prevProps) {
    if (
      this.props.framedView &&
      this.props.framedView !== prevProps.framedView
    ) {
      Celestial.rotate(this.props.framedView)   
    }
  }

  resetMapToCenter() {
    Celestial.rotate({center:[this.state.centerLong, this.state.centerLat]})
  }

  render() {
      return <div ref={el => (this.mapContainer = el)} className="celestial-MainMap" id="celestial-map"></div>
  }    
}
