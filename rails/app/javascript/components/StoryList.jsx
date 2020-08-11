import React, { Component } from "react";
import PropTypes from "prop-types";
import Story from "./Story";
import Filter from "./Filter";
import Sort from "./Sort";
import ReactList from 'react-list';

class StoryList extends Component {
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
    itemOptions: PropTypes.array
  };

  handleClickStory = (story, index) => {
    this.props.onStoryClick(story);
  }

  handleFilterItemChange = (item) => {
    this.props.handleFilterItemChange(item);
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
          <Sort
            stories={this.props.stories}
            handleStoriesChanged={this.props.handleStoriesChanged}
          />
        </div>
        <div className="stories">
          <ReactList
            ref={list => this._list = list }
            itemRenderer={this.renderStory}
            length={this.props.stories.length}
            type='variable'
          />
        </div>
      </React.Fragment>
    );
  }
}

export default StoryList;
