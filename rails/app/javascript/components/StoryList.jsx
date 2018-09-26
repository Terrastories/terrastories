import React, { Component  } from "react";
import PropTypes from "prop-types";
import StoryMedia from "./StoryMedia";

class StoryList extends Component {
  static propTypes = {
    stories: PropTypes.array
  };

  render() {
    return (
      <div className="stories">
        <ul>
          {this.props.stories.map(story => {
            return (
              <li
                className={`story storypoint${story.point && story.point.id}`}
                onClick={_ => this.props.onStoryClick([story.point.lng, story.point.lat])}
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
          })}
        </ul>
      </div>
    );
  }
}

export default StoryList;
