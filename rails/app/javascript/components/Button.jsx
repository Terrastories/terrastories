import React from "react";
import PropTypes from 'prop-types';

const Button = props => {
  const { buttonText, handleClick, buttonType } = props;

  return(
    <button type="button" className={buttonType} onClick={handleClick}>
      {buttonText}
    </button>
  )
}

Button.propTypes = {
  buttonText: PropTypes.string.isRequired,
  handleClick: PropTypes.func.isRequired,
  buttonType: PropTypes.string.isRequired
};

export default Button;