import React, { PureComponent } from "react";
import PropTypes from "prop-types";
import StoryMedia from "./StoryMedia";

class StoryList extends PureComponent {
  static propTypes = {
    stories: PropTypes.array
  };

  render() {
    return (
      <div className="stories">
        <ul>
          {this.props.stories.map(story => {
            return (
              <li className={`story storypoint${story.point && story.point.id}`}>
                <div className="thumbnail placeholder" />
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
