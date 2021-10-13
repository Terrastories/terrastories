import React from 'react';
import { shallow } from 'enzyme';
import Button from '../../../app/javascript/components/Button';

describe('Button component', () => {
  let buttonType = 'explore-button'; 
  let buttonText = 'EXPLORE';
  let wrapper;

  beforeEach(() => {
    global.I18n = {
      t: jest.fn(),
    },
    wrapper = shallow(
      <Button 
        buttonType={buttonType} 
        handleClick={global.I18n.t} 
        buttonText={buttonText} 
      />
    );
  });

  it('Displays correctly', () => {
    expect(wrapper).toMatchSnapshot();
    expect(wrapper.find('.explore-button')).toHaveLength(1);
    expect(wrapper.text()).toEqual('EXPLORE');
  });

  it('Clicks the button', () => {
    wrapper.find('button').simulate('click')

    expect(global.I18n.t).toHaveBeenCalled();
  })
})