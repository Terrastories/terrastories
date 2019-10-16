import React, { Component } from "react";
import PropTypes from 'prop-types';
import StoryList from "./StoryList";

class Card extends Component {

  constructor(props) {
    super(props);
    this.state = {
      isToggleOn: true
    };
  }

  static propTypes = {
    filterMap: PropTypes.object,
    categories: PropTypes.array,
    clearFilteredStories: PropTypes.func,
    handleFilter: PropTypes.func,
    user: PropTypes.object,
    stories: PropTypes.array,
    handleStoriesChanged: PropTypes.func,
    onStoryClick: PropTypes.func,
    logo_path: PropTypes.string,
    activeStory: PropTypes.object
  };

  static defaultProps = {
    filterMap: {},
    categories: [],
    clearFilteredStories: () => { },
    handleFilter: () => { }
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
          <li>{I18n.t("hello")} {this.props.user.email} (<a href={`/${I18n.currentLocale()}`}>{I18n.t("back_to_welcome")}</a>)</li>
          <li><a href={`/admin?locale=${I18n.currentLocale()}`}>{I18n.t("admin_page")}</a></li>
        </ul>
      );
    } else if (this.props.user) {
      return (
        <ul>
          <li>{I18n.t("hello")} {this.props.user.email} (<a href={`/${I18n.currentLocale()}`}>{I18n.t("back_to_welcome")}</a>)</li>
        </ul>
      );
    } else {
      return (
        <ul>
          <li><a href={`/${I18n.currentLocale()}`}>{I18n.t("back_to_welcome")}</a></li>
        </ul>
      );
    }
  }

  render() {
    return (
      <div className={this.state.isToggleOn ? 'cardContainer onCanvas' : 'cardContainer offCanvas'}>
        <div className="tab" onClick={this.handleTray}>
          <div className="arrow" />
        </div>
        <div className="closeMe" onClick={this.handleTray} />
        <div className="card">
          <div className="bar">
            <div className="card--logo">
              <img src={this.props.logo_path} alt="Terrastories" />
            </div>

            <StoryList
              activeStory={this.props.activeStory}
              stories={this.props.stories}
              handleStoriesChanged={this.props.handleStoriesChanged}
              onStoryClick={this.props.onStoryClick}
              handleFilter={this.props.handleFilter}
              clearFilteredStories={this.props.clearFilteredStories}
              filterMap={this.props.filterMap}
              categories={this.props.categories}
            />

            <div className="card--tasks">
              {this.renderUserInformation()}
            </div>
          </div>
        </div>
      </div>
    );
  }
}

export default Card;
