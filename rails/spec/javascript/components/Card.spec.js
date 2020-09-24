import React from 'react';
import { shallow } from 'enzyme';
import Card from '../../../app/javascript/components/Card';

describe('Card component', () => {
  beforeEach(() => {
    global.I18n = {
      currentLocale: jest.fn(),
      t: jest.fn(),
    };
  })

  it('Displays correctly', () => {
    const wrapper = shallow(
      <Card />,
    );

    expect(wrapper).toMatchSnapshot();
    expect(wrapper.find('StoryList')).toHaveLength(1)
  })

  describe('Given a user props', () => {
    describe('With an editor role', () => {
      it('Renders the correct information', () => {
        const wrapper = shallow(
          <Card user={{ role: 'editor' }} />,
        );

        expect(wrapper.find('.card--tasks').childAt(0)).toHaveLength(1);
        expect(global.I18n.currentLocale).toHaveBeenCalledTimes(2);
        expect(global.I18n.t).toHaveBeenCalledWith('hello');
        expect(global.I18n.t).toHaveBeenCalledWith('back_to_welcome');
        expect(global.I18n.t).toHaveBeenCalledWith('admin_page');
      });
    })

    describe('With no role', () => {
      it('Renders the correct information', () => {
        const wrapper = shallow(
          <Card user={{ role: null }} />,
        );

        expect(wrapper.find('.card--tasks').childAt(0)).toHaveLength(1);
        expect(global.I18n.currentLocale).toHaveBeenCalledTimes(1);
        expect(global.I18n.t).toHaveBeenCalledWith('hello');
        expect(global.I18n.t).toHaveBeenCalledWith('back_to_welcome');
        expect(global.I18n.t).not.toHaveBeenCalledWith('admin_page');
      });
    })

    describe('That is null/empty', () => {
      it('Renders the correct information', () => {
        const wrapper = shallow(
          <Card />,
        );

        expect(wrapper.find('.card--tasks').childAt(0)).toHaveLength(1);
        expect(global.I18n.currentLocale).toHaveBeenCalledTimes(1);
        expect(global.I18n.t).not.toHaveBeenCalledWith('hello');
        expect(global.I18n.t).toHaveBeenCalledWith('back_to_welcome');
        expect(global.I18n.t).not.toHaveBeenCalledWith('admin_page');
      });
    })
  });

  it('Toggles the onCanvas/offCanvas CSS classes', () => {
    const wrapper = shallow(
      <Card />,
    );

    expect(wrapper.find('.cardContainer').hasClass('onCanvas')).toBe(true);
    expect(wrapper.find('.cardContainer').hasClass('offCanvas')).toBe(false);
    wrapper.find('.tab').simulate('click');
    expect(wrapper.find('.cardContainer').hasClass('onCanvas')).toBe(false);
    expect(wrapper.find('.cardContainer').hasClass('offCanvas')).toBe(true);
    wrapper.find('.tab').simulate('click');
    expect(wrapper.find('.cardContainer').hasClass('onCanvas')).toBe(true);
    expect(wrapper.find('.cardContainer').hasClass('offCanvas')).toBe(false);
  })
});
