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

  static defaultProps = {
    filterMap: {},
    categories: [],
    clearFilteredStories: () => {}
  }

  handleTray = () => {
    this.setState(prevState => ({
      isToggleOn: !prevState.isToggleOn
    }));
  }

  renderUserInformation = () => {
    if (this.props.user && this.props.user.role === 'editor') {
      return (
        <ul>
          <li>Hello {this.props.user.email} (<a href="/users/sign_out">Logout</a>)</li>
          <li><a href="/admin">Admin Page</a></li>
        </ul>
      );
    } else if (this.props.user) {
      return (
        <ul>
          <li>Hello {this.props.user.email} (<a href="/users/sign_out">Logout</a>)</li>
        </ul>
      );
    }
  }

  render() {
    return (
        <div className={this.state.isToggleOn ? 'card onCanvas' : 'card offCanvas'} >
        <div className="tab" onClick={this.handleTray} />
        <div className="closeMe" onClick={this.handleTray}>
        &times;
        </div>
        <div className="card--logo">
          <img src={this.props.logo_path} alt="Terrastories" />
        </div>

        <div className="card--nav">
          <Filter 
            handleFilter={this.props.handleFilter}
            categories={this.props.categories}
            filterMap={this.props.filterMap}
            clearFilteredStories={this.props.clearFilteredStories}
          />
        </div>

        <StoryList stories={this.props.stories} onStoryClick={this.props.onCardClick}/>

        <div className="card--tasks">
          {this.renderUserInformation()}
        </div>
      </div>
    );
  }
}

export default Card;
