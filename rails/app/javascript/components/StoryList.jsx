import React, { Component } from "react";
import PropTypes from "prop-types";
import StoryMedia from "./StoryMedia";
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

  // In React 16.3.0, update method to getSnapshotBeforeUpdate
  componentWillReceiveProps(nextProps) {
    if(this._list){
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

  handleFilter = (category, item) => {
    this.props.handleFilter(category, item);
    this._list.scrollToPosition(0);
  }

  getStorySpeakerNames = story => {
    return story.speakers.map(function(speaker) { return speaker.name }).join(',');
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
        <li
          className={storyClass}
          onClick={_ => this.props.onStoryClick(story)}
          style={style}
        >
          <div className="speakers">
            {(story.speakers.length === 1) &&
                <div>
                  <img src={story.speakers[0].picture_url} alt={story.speakers[0].name} title={story.speakers[0].name} />
                  <p style={{ fontWeight: 'bold' }}>{story.speakers[0].name}</p>
                </div>}
            {(story.speakers.length > 1) &&
              story.speakers.map(speaker => (
                  <img src={speaker.picture_url} alt={speaker.name} title={speaker.name} />
              ))
            }
            {(story.speakers.length > 1) &&
              <p style={{ fontWeight: 'bold' }}> {this.getStorySpeakerNames(story)} </p>
            }
          </div>
          <div className="container">
            <h6 className="title">{ story.permission_level === "restricted" && "🔒" }{story.title}</h6>
            <p>{story.desc}</p>
            {story.media &&
              story.media.map(file => <StoryMedia file={file} doBustCache={bustCache} key={story.media.id} />)}
          </div>
        </li>
      </CellMeasurer>
    );
  };

  render() {
    return (
      <React.Fragment>
        <div className="card--nav">
          <Filter
            handleFilter={this.handleFilter}
            categories={this.props.categories}
            filterMap={this.props.filterMap}
            clearFilteredStories={this.handleClearFilteredStories}
            filterCategory={this.props.filterCategory}
            filterItem={this.props.filterItem}
            handleFilterCategoryChange={this.props.handleFilterCategoryChange}
            handleFilterItemChange={this.props.handleFilterItemChange}
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
