import React, { PureComponent } from "react";
import StoryList from "./StoryList";

class Card extends PureComponent {

  constructor(props){
    super(props);
    this.state = { isToggleOn: true };
    this.handleTray = this.handleTray.bind(this);
  }

  handleTray() {
    this.setState(prevState => ({
      isToggleOn: !prevState.isToggleOn
    }));
  }

  render() {
    return (
        <div className={this.state.isToggleOn ? 'card onCanvas' : 'card offCanvas'} >
        <div className="tab" onClick={this.handleTray.bind('card offCanvas')}>&#9658;</div>
        <div className="card--logo">
          <img src="assets/logocombo.svg" alt="Terrastories" />
        </div>
 

        <form name="search" className="card--search" method="post">
          <input type="search" placeholder="Search Terrastories" className="search--field"></input>
        </form>

        <div className="card--nav">
          <ul>
            <li><a href="#">Filter 1 ⌄</a></li>
            <li><a href="#">Filter 2 ⌄</a></li>
            <li><a href="#">Filter 3 ⌄</a></li>
          </ul>
        </div>

        <StoryList stories={this.props.stories} />

        <div className="card--tasks">
          <ul>
            <li>Hello admin@terrastories.net (<a href="#">Logout</a>)</li>
          </ul>
        </div>
      </div>
    );
  }
}

export default Card;
