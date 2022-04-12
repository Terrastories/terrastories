import React, { Component } from "react";
import PropTypes from "prop-types";
import Story from "./Story";
import Filter from "./Filter";
import Sort from "./Sort";
import ReactList from 'react-list';
import IntroductoryPanel from "./IntroductoryPanel";
import Button from "./Button";

class StoryList extends Component {
  constructor() {
    super();
    this.state = {
      showStories: false
    };
  }

  static propTypes = {
    stories: PropTypes.array,
    handleStoriesChanged: PropTypes.func,
    handleFilter: PropTypes.func,
    clearFilteredStories: PropTypes.func,
    onStoryClick: PropTypes.func,
    filterMap: PropTypes.object,
    categories: PropTypes.array,
    activeStory: PropTypes.object,
    filterCategory: PropTypes.string,
    filterItem: PropTypes.string,
    handleFilterCategoryChange: PropTypes.func,
    handleFilterItemChange: PropTypes.func,
    itemOptions: PropTypes.array,
    numberOnePath: PropTypes.string,
    numberTwoPath: PropTypes.string
  };

  handleClickExplore = () => {
    this.setState(prevState => ({
      showStories: !prevState.showStories
    }));
  }

  handleClickStory = (story, index) => {
    this.props.onStoryClick(story);
  }

  handleFilterItemChange = (item) => {
    this.props.handleFilterItemChange(item);
    this.setState(() => ({
      showStories: true
    }));
    this._list.scrollTo(0);
  }

  handleClearFilteredStories = () => {
    this.props.clearFilteredStories();
    this._list.scrollTo(0);
  }

  handleSort = (option) => {
    this.props.handleStoriesChanged(option);
    this._list.scrollTo(0);
  }

  renderStory = (index, key) => {
    const story = this.props.stories[index];
    let storyClass = '';
    if (this.props.activeStory && this.props.activeStory.id === story.id) {
      storyClass = `story${index} isActive`
    } else {
      storyClass = `story${index}`;
    }
    return (
        <Story
          story={story}
          onStoryClick={this.props.onStoryClick}
          storyClass={storyClass}
          key={key}
        />
    );
  };

  render() {
    return (
      <React.Fragment>
        <div className="card--nav">
          <Filter
            categories={this.props.categories}
            filterMap={this.props.filterMap}
            clearFilteredStories={this.handleClearFilteredStories}
            filterCategory={this.props.filterCategory}
            filterItem={this.props.filterItem}
            handleFilterCategoryChange={this.props.handleFilterCategoryChange}
            handleFilterItemChange={this.handleFilterItemChange}
            itemOptions={this.props.itemOptions}
          />
        </div>
          {!this.state.showStories && window.innerWidth > 600
            ?
          <div className="card--nav terrastory-info">
            <IntroductoryPanel 
              numberOnePath={this.props.numberOnePath}
              numberTwoPath={this.props.numberTwoPath}
            />
            <Button 
              buttonType='explore-button' 
              handleClick={this.handleClickExplore} 
              buttonText='EXPLORE'
            />
          </div>
            :
            <React.Fragment>
              <div className="card--nav">
                <Sort
                  stories={this.props.stories}
                  handleStoriesChanged={this.props.handleStoriesChanged}
                />
              </div>
              <div className="stories">
                <ReactList
                  ref={list => this._list = list }
                  itemRenderer={this.renderStory}
                  length={this.props.stories ? this.props.stories.length : 0}
                  type='variable'
                />
              </div>
            </React.Fragment>
        }
      </React.Fragment>
    );
  }
}

export default StoryList;
