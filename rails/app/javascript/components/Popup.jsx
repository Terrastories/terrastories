import React from "react";

const Popup = (props) => {
  const { id, name, photo_url, region, type_of_place } = props.feature.properties;
  
  return (
    <div id={`popup-${id}`}>
      <div className="ts-markerPopup-header">
        <h1>{name}</h1>
        <button className="ts-markerPopup-header-button" onClick={props.onCloseClick}>✕</button>
      </div>
      <div className="ts-markerPopup-content">
        {photo_url !== "null" && (<img src={photo_url} />)}
        {region || type_of_place && <div>
          {region !== "null" && <div>Region: {region} </div>}
          {type_of_place !== "null" && <div>Type of Place: {type_of_place} </div>}
        </div> }
      </div>
    </div>
  );
};

export default Popup;
