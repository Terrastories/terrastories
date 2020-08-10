import React, { Component } from "react";
import PropTypes from "prop-types";
import Story from "./Story";
import Filter from "./Filter";
import Sort from "./Sort";
import { List, AutoSizer, CellMeasurer, CellMeasurerCache } from "react-virtualized";

class StoryList extends Component {
  constructor(props) {
    super(props)
    this.cache = new CellMeasurerCache({
      fixedWidth: true,
      defaultHeight: 200
    });
    this._isMounted = false;
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
    itemOptions: PropTypes.array
  };

  componentWillReceiveProps(nextProps) {
    if (this._list) {
      this._list.forceUpdateGrid();
    }
    if (nextProps.stories !== this.props.stories) {
      this._list.recomputeRowHeights();
      this._list.recomputeGridSize();
      this._list.forceUpdateGrid();
    }
  }

  componentDidMount() {
    this._isMounted = true;
  }

  componentWillUnmount() {
    this._isMounted = false;
  }

  handleClickStory = (story, index) => {
    this.props.onStoryClick(story);
  }

  handleFilterItemChange = (item) => {
    this.props.handleFilterItemChange(item);
    // this.resetList();
  }

  handleClearFilteredStories = () => {
    this.props.clearFilteredStories();
    this._list.scrollToPosition(0);
  }

  renderStory = ({ key, index, style, parent }) => {
    const story = this.props.stories[index];
    let storyClass = '';
    if (this.props.activeStory && this.props.activeStory.id === story.id) {
      storyClass = `story${index} isActive`
    } else {
      storyClass = `story${index}`;
    }
    const bustCache = () => {
      this.cache.clear(index, 0);
    }
    
    return (
      <CellMeasurer
        key={key}
        cache={this.cache}
        parent={parent}
        columnIndex={0}
        rowIndex={index}>
          <Story
            story={story}
            onStoryClick={this.props.onStoryClick}
            storyClass={storyClass}
            doBustCache={bustCache}
            style={style}
          />
      </CellMeasurer>
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
          <AutoSizer>
            {({ height, width }) => {
              return (
                <List
                  height={height}
                  width={width}
                  rowCount={this.props.stories.length}
                  deferredMeasurementCache={this.cache}
                  rowHeight={this.cache.rowHeight}
                  rowRenderer={this.renderStory}
                  overscanRowCount={4}
                  ref={list => (this._list = list)}
                />
              );
            }}
          </AutoSizer>
        </div>
      </React.Fragment>
    );
  }
}

export default StoryList;
