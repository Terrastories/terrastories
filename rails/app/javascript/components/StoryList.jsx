import React, { Component  } from "react";
import PropTypes from "prop-types";
import StoryMedia from "./StoryMedia";
import { List, AutoSizer, CellMeasurer, CellMeasurerCache } from "react-virtualized";

class StoryList extends Component {
  constructor(props) {
    super(props)
    this.cache = new CellMeasurerCache({
      fixedWidth: true,
      defaultHeight: 100
    });
  }

  componentWillReceiveProps(nextProps) {
    this._grid.forceUpdateGrid();
  }

  static propTypes = {
    stories: PropTypes.array
  };

  renderStory = ({key, index, style, parent}) => {
    const story = this.props.stories[index];
    return (
      <CellMeasurer 
        key={key}
        cache={this.cache}
        parent={parent}
        columnIndex={0}
        rowIndex={index}>
          <li
            className={`story storypoint${story.point && story.point.id}`}
            onClick={_ => this.props.onStoryClick([story.point.lng, story.point.lat])}
            key={key}
            style={style}
          >
            <div className="speakers">
              <img src={story.speaker.picture_url} alt={story.speaker.name} title={story.speaker.name}/>
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
                overscanRowCount={3}
                ref={grid => (this._grid = grid)}
              />
            );
          }}
        </AutoSizer>
      </div>
    );
  }
}

export default StoryList;
