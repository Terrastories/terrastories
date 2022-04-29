import React from "react";

const Popup = (props) => {
  const { id, name, photo_url, name_audio_url, description, region, type_of_place } = props.feature.properties;
  
  return (
    <div id={`popup-${id}`}>
      <div className="ts-markerPopup-header">
        <h1>{name}</h1>
        <button className="ts-markerPopup-header-button" onClick={props.onCloseClick}>✕</button>
      </div>
      <div className="ts-markerPopup-content">
        {photo_url && (<img src={photo_url} />)}
        {name_audio_url && (<div><span className="ts-markerPopup-label">{I18n.t("place_name")}:</span>
                                                      <audio className="ts-markerPopup-audio"
                                                      controls
                                                      controlsList="nodownload"
                                                      src={name_audio_url}> </audio></div>)}
        {description && (<div className="ts-markerPopup-description">{description}</div>)}
        {region && (<div><span className="ts-markerPopup-label">{I18n.t("region")}:</span> {region}</div>)}
        {type_of_place && (<div><span className="ts-markerPopup-label">{I18n.t("place_type")}:</span> {type_of_place}</div>)}
      </div>
    </div>
  );
};

export default Popup;