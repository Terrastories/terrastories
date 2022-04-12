import React from 'react';
import { shallow } from 'enzyme';
import StoryList from '../../../app/javascript/components/StoryList';

describe('StoryList Component', () => {
  let wrapper;

  beforeEach(() => {
    global.I18n = {
      t: jest.fn(),
    },
    wrapper = shallow(
      <StoryList />,
    );
  })

  it('Displays correctly', () => {
    expect(wrapper).toMatchSnapshot();
    expect(wrapper.find('Filter')).toHaveLength(1);
    expect(wrapper.find('IntroductoryPanel')).toHaveLength(1);
    expect(wrapper.find('Button')).toHaveLength(1);
  })

  it('Clicks the explore button', () => {
    wrapper.find('Button').props.handleClick = global.I18n.t;
    wrapper.find('Button').props.handleClick();

    expect(global.I18n.t).toHaveBeenCalled();
  })
})