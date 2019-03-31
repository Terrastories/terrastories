
import React from 'react'
import StoryList from '../../app/javascript/components/StoryList'
import { render } from 'react-testing-library'

import { stories } from './fakes/stories'

describe('<StoryList> component', () => {
  it('renders correctly with a list of stories', () => {

    const {container} = render( <StoryList stories={stories}/>)
    expect(container.firstChild).toMatchSnapshot()
  })
})
