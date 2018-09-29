import React, { Component } from "react";
import StoryList from "./StoryList";
import Filter from "./Filter";

class Card extends Component {

  constructor(props){
    super(props);
    this.state = { 
      isToggleOn: true
    };
  }

  handleTray = () => {
    this.setState(prevState => ({
      isToggleOn: !prevState.isToggleOn
    }));
  }

  render() {
    return (
        <div className={this.state.isToggleOn ? 'card onCanvas' : 'card offCanvas'} >
        <div className="tab" onClick={this.handleTray}>&#9658;</div>
        <div className="closeMe" onClick={this.handleTray}>
        &times;
        </div>
        <div className="card--logo">
          <img src={this.props.logo_path} alt="Terrastories" />
        </div>

       <form name="search" className="card--search" method="post">
          <input type="search" placeholder="Search Terrastories" className="search--field"></input>
        </form> 

        <div className="card--nav">
          <Filter handleFilter={this.props.handleFilter} />
        </div>

        <StoryList stories={this.props.stories} onStoryClick={this.props.onCardClick}/>

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
