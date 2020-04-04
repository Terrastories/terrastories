import React, { PureComponent } from "react";

class IntroPopup extends PureComponent {

  constructor(props){
    super(props);
    this.state = { isPopped: true }
  }

  handleIntroPopup = () => {
    this.setState(prevState =>({
      isPopped: !prevState.isPopped
    }));
  }

  render(){
    return(
      <div className={this.state.isPopped ? 'intro-card isShown' : 'intro-card isHidden'}>
        <h2>{I18n.t("introduction")}</h2>
        <h3>{I18n.t("intro.question")}</h3>
        <p>{I18n.t("intro.explanation")}</p>

        <div className="intro-card--actions">
          <span className="count" onClick={this.handleIntroPopup}>{I18n.t("close")}</span>
        </div>
      </div>
    );
  }

}

export default IntroPopup;
