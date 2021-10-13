import React from "react";
import PropTypes from 'prop-types';

const IntroductoryPanel = (props) => {
  const { numberOnePath, numberTwoPath } = props;

  return (
    <React.Fragment>
      <span className="card--nav-intro">{I18n.t("intro.question")}</span>
      <p>{I18n.t("intro.explanation")}</p>
      <span className="card--nav-intro">{I18n.t("usage.question")}</span>
      <div className="card--nav-usage">
        <div className="first-info">
          <div className="first-img">
            <img src={numberOnePath} alt="First" />
          </div>
          <p>{I18n.t("usage.category_explanation")}</p>
        </div>
        <div>
          <div className="second-img">
            <img src={numberTwoPath} alt="Second" />
          </div>  
          <p>{I18n.t("usage.option_explanation")}</p>
        </div>
      </div>
      <p>{I18n.t("usage.explore_explanation")}</p>
    </React.Fragment>
  )
}

IntroductoryPanel.propTypes = {
  numberOnePath: PropTypes.string,
  numberTwoPath: PropTypes.string
};

export default IntroductoryPanel;