import React, { Component } from "react";
import PropTypes from "prop-types";
import StoryMedia from "./StoryMedia";
import Filter from "./Filter";
import { List, AutoSizer, CellMeasurer, CellMeasurerCache } from "react-virtualized";

class StoryList extends Component {
  constructor(props) {
    super(props)
    this.cache = new CellMeasurerCache({
      fixedWidth: true,
      defaultHeight: 100
    });
    this.state = {
      activeStoryIndex: null
    };
  }

  static propTypes = {
    stories: PropTypes.array,
    handleFilter: PropTypes.func,
    clearFilteredStories: PropTypes.func,
    onStoryClick: PropTypes.func,
    filterMap: PropTypes.object,
    categories: PropTypes.array,
    activeStory: PropTypes.object
  };

  // In React 16.3.0, update method to getSnapshotBeforeUpdate
  componentWillReceiveProps(nextProps) {
    this.cache.clearAll();
    if(this._list){
      this._list.recomputeRowHeights();
      this._list.forceUpdateGrid();
    }
  }

  handleFilter = (category, item) => {
    this.props.handleFilter(category, item);
  }

  renderStory = ({ key, index, style, parent }) => {
    const story = this.props.stories[index];
    const storyClass = this.props.activeStory && this.props.activeStory.id === story.id ? `story${index} isActive` : `story${index}`;
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
          key={key}
          style={style}
        >
          <div className="speakers">
            {story.speakers.map(speaker => (
              <div key={speaker.id}>
                <img src={speaker.picture_url} alt={speaker.name} title={speaker.name} />
                <p style={{ fontWeight: 'bold' }}>{speaker.name}</p>
              </div>
            )
            )}
          </div>
          <div className="container">
            <h6 className="title">{story.title}</h6>
            <p>{story.desc}</p>
            {story.media &&
              story.media.map(file => <StoryMedia file={file} doBustCache={bustCache} />)}
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
            clearFilteredStories={this.props.clearFilteredStories}
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
                  overscanRowCount={2}
                  scrollToIndex={this.state.activeStoryIndex || 0}
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
