import React from "react";

const Popup = (props) => {
  const { id, name, description } = props.feature.properties;

  return (
    <div id={`popup-${id}`}>
      <span onClick={props.onCloseClick}>✕</span>
      <h3>{name}</h3>
      {description}
    </div>
  );
};

export default Popup;

// buildPopupHTML(marker) {
//   if (marker.properties.photo_url) {
//     if (marker.properties.region) {
//       if (marker.properties.type_of_place) {
//         return `<h1>${marker.properties.name}</h1>
//         <div class="ts-markerPopup-content">
//           <img src=${marker.properties.photo_url} />
//           <div>
//             <div>${I18n.t("region")}: ${marker.properties.region}</div>
//             <div>${I18n.t("place_type")}: ${
//           marker.properties.type_of_place
//         }</div>
//           </div>
//         </div>`;
//       } else {
//         return `<h1>${marker.properties.name}</h1>
//         <div class="ts-markerPopup-content">
//           <img src=${marker.properties.photo_url} />
//           <div>
//             <div>${I18n.t("region")}: ${marker.properties.region}</div>
//           </div>
//         </div>`;
//       }
//     } else {
//       return `<h1>${marker.properties.name}</h1>
//         <div class="ts-markerPopup-content">
//           <img src=${marker.properties.photo_url} />
//         </div>`;
//     }
//   } else {
//     if (marker.properties.region) {
//       if (marker.properties.type_of_place) {
//         return `<h1>${marker.properties.name}</h1>
//         <div class="ts-markerPopup-content">
//           <div>
//             <div>${I18n.t("region")}: ${marker.properties.region}</div>
//             <div>${I18n.t("place_type")}: ${
//           marker.properties.type_of_place
//         }</div>
//           </div>
//         </div>`;
//       } else {
//         return `<h1>${marker.properties.name}</h1>
//         <div class="ts-markerPopup-content">
//           <div>
//             <div>${I18n.t("region")}: ${marker.properties.region}</div>
//           </div>
//         </div>`;
//       }
//     } else {
//       return `<h1>${marker.properties.name}</h1>
//         <div class="ts-markerPopup-content">
//         </div>`;
//     }
//   }
// }