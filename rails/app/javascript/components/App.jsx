import React, { Component } from 'react';
import Map from './Map';
import Card from './Card';
import IntroPopup from './IntroPopup';


class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      coords: [],
      points: {},
      stories: this.props.stories
    }
  }

  componentDidMount() {
    this.getPointsFromStories(this.props.stories);
    console.log(this.props.stories);
    console.log(this.getPointsFromStories(this.props.stories));
  }

  setPointCoords = coords => {
    this.setState({coords});
  }

  getPointsFromStories = stories => {
    const points = stories.map(story => story.point);
    const pointObj = {};
    pointObj['features'] = points;
    console.log(pointObj, 'THE POINT OBJ');
    this.setState({points: pointObj});
  }

  handleFilter = (typeOfFilter, value) => {
    // Test for Region, Kumiade
    const filter = typeOfFilter.toLowerCase();
    const filteredStories = this.props.stories.filter(story => {
      if (story.point[filter] === value) {
        return story;
      }
    });
    const filteredPoints = this.getPointsFromStories(filteredStories);
    this.setState({stories: filteredStories, points: filteredPoints});
    console.log('Filtered Stories!', filteredStories);
  }

  render() {
    return (
      <div>
        <Map points={this.state.points} pointCoords={this.state.coords}/>
        <Card 
          stories={this.props.stories}
          handleFilter={this.handleFilter}
          onCardClick={this.setPointCoords}
          logo_path={this.props.logo_path}
        />
        <IntroPopup />
      </div>
    );
  }
}
export default App;
