import React from 'react';
import { shallow } from 'enzyme';
import StoryMedia from 'components/StoryMedia';
it('should render correctly in "image" mode', () => {
    const props = {
        file: {
            url: '',
            blob: {
                id: 2,
                content_type: 'awesome'
            }
        }
    }
    const component = shallow(<StoryMedia {...props} />);

    expect(component).toMatchSnapshot();
    expect(component.find('img').exists()).toBe(true)
});