import React from 'react';
import { shallow } from 'enzyme';
import IntroPopup from 'components/IntroPopup';

describe("IntroPopup", () => {
    let props;
    let t_count;
    let component;

    beforeAll(() => {
        global.I18n = require('./__mocks__/I18n.mock.js');
        props = { isPopped: true };
        t_count = I18n.t.mock.calls.length;
        component = shallow(<IntroPopup {...props} />);
    });

    it("should render correctly", () => {
        expect(component).toMatchSnapshot();
        let divs = component.find("div");
        expect(divs.first().hasClass("intro-card")).toBe(true);
        expect(divs.last().hasClass("intro-card--actions")).toBe(true);
    });

    describe ("should use localized text:", () => {
        it("makes calls to I18n", () => {
            expect(I18n.t.mock.calls.length).toBeGreaterThan(t_count);
        });
        it("renders the localized text", () => {
            expect(I18n.t).toHaveBeenCalledWith("introduction");
            expect(I18n.t).toHaveBeenCalledWith("intro.question");
            expect(I18n.t).toHaveBeenCalledWith("intro.explanation");
            expect(I18n.t).toHaveBeenCalledWith("close");
        })
    });

    it("should initially pop up and then close when clicked", () => {
        let clickComponent = shallow(<IntroPopup {...props} />);
        let introCard = clickComponent.find("div.intro-card");
        expect(introCard.length).toBe(1);
        expect(introCard.hasClass("isShown")).toBe(true);
        expect(introCard.hasClass("isHidden")).toBe(false);
        clickComponent.find("div.intro-card--actions > span").simulate('click');
        /* IntroPopup should have re-rendered, so we need to re-find introCard */
        introCard = clickComponent.find("div.intro-card");
        expect(introCard.length).toBe(1);
        expect(introCard.hasClass("isShown")).toBe(false);
        expect(introCard.hasClass("isHidden")).toBe(true);
    });

    it("should default to popped up when no prop is given", () => {
        let defaultComponent = shallow(<IntroPopup />);
        expect(defaultComponent.state("isPopped")).toBe(true);
        let introCard = defaultComponent.find("div.intro-card");
        expect(introCard.length).toBe(1);
        expect(introCard.hasClass("isShown")).toBe(true);
    });

    //TODO: CODE REVIEW: Decide if this would be a future desired behavior, un-skip if so, otherwise delete
    describe.skip("should recognize the supplied props:", () => {
        describe("isPopped: {boolean}", () => {
            it("should display popped up when isPopped is true", () => {
                let popProps = {...props};
                popProps.isPopped = true;
                let poppedComponent = shallow(<IntroPopup {...popProps}/>);
                expect(poppedComponent.state("isPopped")).toBe(true);
                let introCard = poppedComponent.find("div.intro-card");
                expect(introCard.hasClass("isShown")).toBe(true);
            });
            it("should display hidden when isPopped is false", () => {
                let popProps = {...props};
                popProps.isPopped = false;
                let poppedComponent = shallow(<IntroPopup {...popProps}/>);
                expect(poppedComponent.state("isPopped")).toBe(false);
                let introCard = poppedComponent.find("div.intro-card");
                expect(introCard.hasClass("isHidden")).toBe(true);
            });
        });
    });
});