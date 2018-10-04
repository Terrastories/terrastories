import React, { Component  } from "react";
import PropTypes from "prop-types";
import StoryMedia from "./StoryMedia";
import {AutoSizer} from 'react-virtualized/dist/commonjs/AutoSizer';
import {List} from 'react-virtualized/dist/commonjs/List';

class StoryList extends Component {
  static propTypes = {
    stories: PropTypes.array
  };

  renderStory = ({key, index, style}) => {
    const story = this.props.stories[index];
    return (
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
                rowHeight={height}
                rowRenderer={this.renderStory}
                overscanRowCount={1}
              />
            );
          }}
        </AutoSizer>
      </div>
    );
  }
}

export default StoryList;
