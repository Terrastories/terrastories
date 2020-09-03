import React from "react";
import PropTypes from "prop-types";
import StoryMedia from "./StoryMedia";

const Story = props => {
  const story = props.story;

  const renderSpeakers = speakers => {
    return (
      <div key={`${story.id}-speakers`}>
        {
          speakers.map(speaker => {
            return (
              <img
                src={speaker.picture_url}
                alt={speaker.name}
                title={speaker.name}
                key={speaker.id}
              />
            );
          })
        }
        <p style={{ fontWeight: 'bold' }}>
          {
            speakers.map(speaker => {
              return speaker.name
            }).join(',')
          }
        </p>
      </div>
    );
  }

  return (
    <React.Fragment>
      <li
        className={props.storyClass}
        onClick={_ => props.onStoryClick(story)}
        key={story.id}
      >
        <div className="speakers">
          {renderSpeakers(story.speakers)}
        </div>
        <div className="container">
          <h6 className="title">
            {story.permission_level === "restricted" && "🔒"} {story.title}
          </h6>
          <p>{story.desc}</p>
          {
            story.media &&
            story.media.map(file =>
              <StoryMedia
                file={file}
                key={story.media.id}
                doBustCache={props.doBustCache}
              />
            )
          }
        </div>
      </li>
    </React.Fragment>
  );
}

Story.propTypes = {
  story: PropTypes.object,
  onStoryClick: PropTypes.func,
  storyClass: PropTypes.string,
  doBustCache: PropTypes.func,
  style: PropTypes.object,
};

Story.defaultProps = {
  story: {},
  onStoryClick: () => { },
  storyClass: "",
  doBustCache: () => { },
  style: {}
};

export default Story;