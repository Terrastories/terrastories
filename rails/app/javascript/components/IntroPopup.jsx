import React, { PureComponent } from "react";
import { withTranslation } from 'react-i18next';

class IntroPopup extends PureComponent {

  constructor(props){
    super(props);
    this.state = { 
      isPopped: true,
    }
  }

  handleIntroPopup = () => {
    this.setState(prevState =>({
      isPopped: !prevState.isPopped
    }));
  }

  render(){
    return(
      <div className={this.state.isPopped ? 'intro-card isShown' : 'intro-card isHidden'}>
        <h2>{this.props.t("introduction")}</h2>
        <h3>{this.props.isStellarstories ? this.props.t("intro_stellarstories.question") : this.props.t("intro.question")}</h3>
        <p>{this.props.isStellarstories ? this.props.t("intro_stellarstories.explanation") : this.props.t("intro.explanation")}</p>

        <div className="intro-card--actions">
          <span className="count" onClick={this.handleIntroPopup}>{this.props.t("close")}</span>
        </div>
      </div>
    );
  }

}

export default withTranslation()(IntroPopup);
