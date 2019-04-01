
import React from 'react'
import StoryMedia from '../../app/javascript/components/StoryMedia'
import { render } from 'react-testing-library'

describe('<StoryMedia> component', () => {
  it('renders correctly with a video file', () => {
    const videoFile = {
      blob: {
        content_type: 'video'
      }
    }
    const {container} = render( <StoryMedia file={videoFile} />)
    expect(container.firstChild).toMatchSnapshot()
  })

  it('renders correctly without a video', () => {
    const audioFile = {
      blob: {
        content_type: 'audio'
      }
    }
    const {container} = render( <StoryMedia file={audioFile} />)
    expect(container.firstChild).toMatchSnapshot()
  })
})
