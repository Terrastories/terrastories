import React from "react";
import PropTypes from "prop-types";
import { useTranslation } from 'react-i18next';
import StoryMedia from "./StoryMedia";

const Story = props => {
  const { t } = useTranslation();
  const { onStoryClick, story, storyClass } = props;

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
            }).join(', ')
          }
        </p>
      </div>
    );
  }

  return (
    <>
      <li
        className={storyClass}
        onClick={() => onStoryClick(story)}
        onKeyDown={() => onStoryClick(story)}
        key={story.id}
        role="presentation"
      >
        {
          story.story_pinned && (
            <div className="pinned">
              <svg viewBox="0 -960 960 960" xmlns="http://www.w3.org/2000/svg">
                <path d="m634-448 86 77v60H510v241l-30 30-30-30v-241H240v-60l80-77v-333h-50v-60h414v60h-50v333Z"/>
              </svg>
            </div>
          )
        }
        <div className="speakers">
          {renderSpeakers(story.speakers)}
        </div>
        <div className="container">
          <h6 className="title">
            {story.title}
            {story.permission_level === "restricted" && " 🔒"}
          </h6>
          <p className="description">{story.desc}</p>
          {
            story.media &&
            story.media.map(file => (
              <StoryMedia
                file={file}
                key={story.media.id}
              />
            ))
          }
          {
            story.language && (
              <p>
                <b>
                  {t("language")}
                  :
                </b>
                {' '}
                {story.language}
              </p>
            )
          }
        </div>
      </li>
    </>
  );
}

Story.propTypes = {
  story: PropTypes.object,
  onStoryClick: PropTypes.func,
  storyClass: PropTypes.string,
};

Story.defaultProps = {
  story: {},
  onStoryClick: () => { },
  storyClass: "",
};

export default Story;
