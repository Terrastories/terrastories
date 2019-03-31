
import React from 'react'
import Filter from '../../app/javascript/components/Filter'
import { render } from 'react-testing-library'

describe('<Filter> component', () => {
  it('renders correctly with no props', () => {
    const {container} = render( <Filter />)
    expect(container.firstChild).toMatchSnapshot()
  })
})
