import React from "react";

const Popup = (props) => {
  const { id, name, photo_url, name_audio_url, description, region, type_of_place } = props.feature.properties;
  
  return (
    <div id={`popup-${id}`}>
      <div className="ts-markerPopup-header">
        <h1>{name}</h1>
        <button className="ts-markerPopup-header-button" onClick={props.onCloseClick}>✕</button>
      </div>
      // To do post-refactor: internationalize label strings in popup
      <div className="ts-markerPopup-content">
        {photo_url !== undefined && (<img src={photo_url} />)}
        {name_audio_url !== undefined && (<div><span class="ts-markerPopup-label">Place name pronunciation:</span>
                                                      <audio class="ts-markerPopup-audio"
                                                      controls
                                                      controlsList="nodownload"
                                                      src={name_audio_url}> </audio></div>)}
        {description && (<div class="ts-markerPopup-description">{description}</div>)}
        {console.log(description)}
        {region && (<div><span class="ts-markerPopup-label">Region:</span> {region}</div>)}
        {type_of_place && (<div><span class="ts-markerPopup-label">Type of Place:</span> {type_of_place}</div>)}
      </div>
    </div>
  );
};

export default Popup;
