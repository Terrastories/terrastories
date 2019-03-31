import React, { Component } from 'react';
import Map from './Map';
import Card from './Card';
import IntroPopup from './IntroPopup';
import {FILTER_CATEGORIES} from '../constants/FilterConstants';
class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      pointCoords: [],
      points: {},
      stories: this.props.stories
    }
  }

  componentDidMount() {
    const points = this.getPointsFromStories(this.state.stories);
    this.setState({points: points});
  }

  setPointCoords = pointCoords => {
    this.setState({pointCoords});
  }

  getPointsFromStories = stories => {
    const points = stories.map(story => story.point);
    const pointObj = {};
    pointObj['features'] = points;
    return pointObj;
  }

  filterMap = () => {
    // Build Filter Map for Dropdowns
    // {category name: array of items}
    let filterMap = {};
    FILTER_CATEGORIES.map(category => {
      switch (category) {
        case FILTER_CATEGORIES[0]: {
          // first category: Region
          const regionSet = new Set(this.props.stories.map(story => {
            return story.point.properties.region
          }));
          filterMap[category] = Array.from(regionSet).sort();
          break;
        }
        case FILTER_CATEGORIES[1]: {
          // second category: Type of Place
          const typeOfPlaceSet = new Set(this.props.stories.map(story => {
            return story.place.type_of_place;
          }));
          filterMap[category] = Array.from(typeOfPlaceSet).sort();
          break;
        }
        case FILTER_CATEGORIES[2]: {
          // third category: Speaker
          const speakerSet = new Set(this.props.stories.map(story => {
            return story.speaker.name
          }));
          filterMap[category] = Array.from(speakerSet).sort();
          break;
        }
      }
    });
    return filterMap;
  }

  clearFilteredStories = () => {
    const points = this.getPointsFromStories(this.props.stories);

    this.setState({
      stories: this.props.stories,
      points: points
    });
  }

  handleFilter = (category, item) => {
    let filteredStories = [];
    switch (category) {
      case FILTER_CATEGORIES[0]: {
        // first category: region
        filteredStories = this.props.stories.filter(story => {
          if (story.point.properties.region && story.point.properties.region.toLowerCase() === item.toLowerCase()) {
            return story;
          }
        });
        break;
      }
      case FILTER_CATEGORIES[1]: {
        // second category: type of place
        filteredStories = this.props.stories.filter(story => {
          if (story.place['type_of_place'].toLowerCase() === item.toLowerCase()) {
            return story;
          }
        });
        break;
      }
      case FILTER_CATEGORIES[2]: {
        // third category: speaker name
        filteredStories = this.props.stories.filter(story => {
          if (story.speaker.name.toLowerCase() === item.toLowerCase()) {
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
    (`Filtered Stories of ${category} ${item}:`, filteredStories);
  }

  showMapPointStories = stories => {
    let storyPointIds = stories.map(story => story.point_id);
    let filteredStories = [];
    filteredStories = this.props.stories.filter(story => storyPointIds.includes(story.point.id));
    if (filteredStories) {
      this.setState({ stories: filteredStories });
    }
  }

  render() {
    return (
      <div>
        <Map
          points={this.state.points}
          pointCoords={this.state.pointCoords}
          mapboxAccessToken={this.props.mapbox_access_token}
          mapboxStyle={this.props.mapbox_style}
          onMapPointClick={this.showMapPointStories}
          clearFilteredStories={this.clearFilteredStories}
        />
        <Card
          stories={this.state.stories}
          categories={FILTER_CATEGORIES}
          filterMap={this.filterMap()}
          handleFilter={this.handleFilter}
          clearFilteredStories={this.clearFilteredStories}
          onCardClick={this.setPointCoords}
          logo_path={this.props.logo_path}
          user={this.props.user}
        />
        <IntroPopup />
      </div>
    );
  }
}
export default App;
