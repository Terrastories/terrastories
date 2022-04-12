import React from 'react';
import { shallow } from 'enzyme';
import IntroductoryPanel from '../../../app/javascript/components/IntroductoryPanel';

describe('IntroductoryPanel Component', () => {
  let numberOnePath = 'first.svg';
  let numberTwoPath = 'second.svg';
  let wrapper;

  beforeEach(() => {
    global.I18n = require('./__mocks__/I18n.mock.js'),
    wrapper = shallow(
                <IntroductoryPanel 
                  numberOnePath={numberOnePath} 
                  numberTwoPath={numberTwoPath} 
                />);
  })

  it('Displays correctly', () => {
    expect(wrapper).toMatchSnapshot();
    expect(wrapper.find('span').find('.card--nav-intro')).toHaveLength(2);
    expect(wrapper.find('div').find('.card--nav-usage')).toHaveLength(1);
    expect(wrapper.find('div').find('.first-info')).toHaveLength(1);
    expect(wrapper.find('div').find('.first-img')).toHaveLength(1);
    expect(wrapper.find('div').find('.second-img')).toHaveLength(1);  
    expect(wrapper.find('img').first().prop('src')).toEqual('first.svg');
    expect(wrapper.find('img').last().prop('src')).toEqual('second.svg');
  })

  it('Renders the localized text', () => {
    expect(I18n.t).toHaveBeenCalledWith('intro.question');
    expect(I18n.t).toHaveBeenCalledWith('usage.question');
    expect(I18n.t).toHaveBeenCalledWith('usage.category_explanation');
    expect(I18n.t).toHaveBeenCalledWith('usage.option_explanation');
    expect(I18n.t).toHaveBeenCalledWith('usage.explore_explanation');
  })
})