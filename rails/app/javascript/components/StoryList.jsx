import React, { Component  } from "react";
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
    onStoryClick: PropTypes.func
  };

  handleClickStory = (story, index) => {
    this.setState({
      activeStoryIndex: index
    }, this._list.forceUpdateGrid());
    this.props.onStoryClick(story.point.geometry.coordinates);
  }

  handleFilter = (category, item) => {
    this.resetActiveStory();
    this.props.handleFilter(category, item);
  }

  clearFilteredStories = () => {
    this.resetActiveStory();
    this.props.clearFilteredStories();
  }

  resetActiveStory = () => {
    this.setState({
      activeStoryIndex: null
    }, this._list.forceUpdateGrid());
  }

  renderStory = ({key, index, style, parent}) => {
    const story = this.props.stories[index];
    const storyClass = this.state.activeStoryIndex === index ? `story${index} isActive` : `story${index}`;
    return (
      <CellMeasurer 
        key={key}
        cache={this.cache}
        parent={parent}
        columnIndex={0}
        rowIndex={index}>
          <li
            className={storyClass}
            onClick={_ => this.handleClickStory(story, index)}
            key={key}
            style={style}
          >
            <div className="speakers">
              <img src={story.speaker.picture_url}/>
              <p style={{ fontWeight: 'bold' }}>{story.speaker.name}</p>
            </div>
            <div className="container">
              <h6 className="title">{story.title}</h6>
              <p>{story.desc}</p>
              {story.media &&
                story.media.map(file => <StoryMedia file={file} />)}
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
          clearFilteredStories={this.clearFilteredStories}
        />
      </div>
        <div className="stories">
          <AutoSizer>
            {({height, width}) => {
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
