import React, { PureComponent } from "react";
import PropTypes from "prop-types";

class IntroPopup extends PureComponent {

  constructor(props){
    super(props);
    this.state = { isPopped: true }
    this.handleIntroPopup = this.handleIntroPopup.bind(this);
  }

  handleIntroPopup = () => {
    this.setState(prevState =>({
      isPopped: !prevState.isPopped
    }));
  }

  render(){
    return(
      <div className={this.state.isPopped ? 'intro-card isShown' : 'intro-card isHidden'}>
        <h2>Introduction</h2>
        <h3>What's a Terrastory?</h3>
        <p>Terrastories are audiovisual recordings of place-based storytelling. This offline-compatible application enables local communities to locate and map their own oral storytelling traditions about places of significant meaning or value to them.</p>

        <div className="intro-card--actions">
          <span className="count" onClick={this.handleIntroPopup.bind('intro-card isHidden')}>Close</span>
        </div>
      </div>
    );
  }

}

export default IntroPopup;