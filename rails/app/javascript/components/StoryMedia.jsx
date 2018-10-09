import React, { PureComponent } from "react";

class StoryMedia extends PureComponent {
  renderAudio() {
    const { file } = this.props;
    return (
      <audio id={`audio-player${file.id}`} controls>
        <source src={file.url} type={file.blob.content_type} />
      </audio>
    );
  }

  renderVideo() {
    const { file } = this.props;
    return (
      <video
        id={`video-player${file.id}`}
        className="video-player"
        playsinline
        controls
      >
        <source src={`/assets/${file.temporary_filename}`} type={file.blob.content_type} />
      </video>
    );
  }

  render() {
    return this.props.file.blob.content_type.indexOf("video") !== -1
      ? this.renderVideo()
      : this.renderAudio();
  }
}

export default StoryMedia;
