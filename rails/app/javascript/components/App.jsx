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
    console.log(this.props.stories, 'Component Did Mount Stories');
    console.log(this.getPointsFromStories(this.props.stories), 'Component Did Mount Points');
  }

  setPointCoords = coords => {
    this.setState({coords});
  }

  getPointsFromStories = stories => {
    const points = stories.map(story => story.point);
    const pointObj = {};
    pointObj['features'] = points;
    this.setState({points: pointObj});
  }

  handleFilter = (category, item) => {
    const filterCategory = category.toLowerCase();
    let filteredStories = [];
    switch (filterCategory) {
      case 'region': {
        filteredStories = this.props.stories.filter(story => {
          if (story.point.properties[filterCategory] === item) {
            return story;
          }
        });
        break;
      }
      case 'type of place': {
        // filteredStories = this.props.stories.filter(story => {
        //   if (story.point.place['type_of_place'] === item) {
        //     return story;
        //   }
        // });
        console.log('filter by type of place');
        // search thru the points places
        // add places to the json jbuilder
        break;
      }
      case 'speaker': {
        filteredStories = this.props.stories.filter(story => {
          if (story.speaker.name === item) {
            return story;
          }
        });
        break;
      }
    }
    if (filteredStories) {
      const filteredPoints = this.getPointsFromStories(filteredStories);
      this.setState({stories: filteredStories, points: filteredPoints});
    }
    console.log(`Filtered Stories of ${category} ${item}:`, filteredStories);
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
