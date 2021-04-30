import React, { Component } from "react";
import PropTypes from "prop-types";
import Map from "./Map";
import Card from "./Card";
import IntroPopup from "./IntroPopup";
import FILTER_CATEGORIES from "../constants/FilterConstants";
import bbox from "@turf/bbox";

let DEFAULT_CATEGORY_PLACEHOLDER = I18n.t("select_category");
let DEFAULT_ITEM_PLACEHOLDER = I18n.t("select_option");

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      framedView: null, // store information about how view should be laid out
      points: {},
      stories: this.props.stories,
      activePoint: null,
      activeStory: null,
      filterCategory: DEFAULT_CATEGORY_PLACEHOLDER,
      filterItem: DEFAULT_ITEM_PLACEHOLDER,
      itemOptions: [],
    }
  }

  static propTypes = {
    stories: PropTypes.array,
    use_local_map_server: PropTypes.bool,
    mapbox_access_token: PropTypes.string,
    mapbox_style: PropTypes.string,
    logo_path: PropTypes.string,
    user: PropTypes.object,
    center_lat: PropTypes.string,
    center_long: PropTypes.string,
    zoom: PropTypes.number,
    sw_boundary_lat: PropTypes.string,
    sw_boundary_long: PropTypes.string,
    ne_boundary_lat: PropTypes.string,
    ne_boundary_long: PropTypes.string,
    pitch: PropTypes.number,
    bearing: PropTypes.string
  };

  componentDidMount() {
    const points = this.getPointsFromStories(this.state.stories);
    this.setState({ points: points });
  }

  getPointsFromStories = stories => {
    const points = stories.map(story => story.points).flat();
    const pointObj = {
      type: "FeatureCollection",
      features: points
    };
    return pointObj;
  };

  filterMap = () => {
    // Build Filter Map for Dropdowns
    // {category name: array of items}
    let filterMap = {};
    FILTER_CATEGORIES.map(category => {
      switch (category) {
        case FILTER_CATEGORIES[0]: {
          // first category: Region
          const regionSet = new Set(
            this.props.stories
              .map(story => {
                return story.points.map(point => point.properties.region);
              })
              .flat()
          );
          filterMap[category] = Array.from(regionSet).sort();
          break;
        }
        case FILTER_CATEGORIES[1]: {
          // second category: Type of Place
          const typeOfPlaceSet = new Set(
            this.props.stories
              .map(story => {
                return story.points.map(
                  point => point.properties.type_of_place
                );
              })
              .flat()
          );
          filterMap[category] = Array.from(typeOfPlaceSet).sort();
          break;
        }
        case FILTER_CATEGORIES[2]: {
          // third category: Speaker
          const speakerSet = new Set(
            this.props.stories
              .map(story => {
                return story.speakers.map(speaker => speaker.name);
              })
              .flat()
          );
          filterMap[category] = Array.from(speakerSet).sort();
          break;
        }
        case FILTER_CATEGORIES[3]: {
          // second category: Topic
          const topicSet = new Set(
            this.props.stories
              .map(story => {
                return story.points.map(
                  point => point.properties.topic
                );
              })
              .flat()
          );
          filterMap[category] = Array.from(topicSet).sort();
          break;
        }
      }
    });
    return filterMap;
  };

  handleFilter = (category, item) => {
    let filteredStories = [];
    switch (category) {
      case FILTER_CATEGORIES[0]: {
        // first category: region
        filteredStories = this.props.stories.filter(story => {
          if (
            story.points.some(point => {
              return (
                point.properties.region &&
                point.properties.region.toLowerCase() === item.toLowerCase()
              );
            })
          ) {
            return story;
          }
        });
        break;
      }
      case FILTER_CATEGORIES[1]: {
        // second category: type of places
        filteredStories = this.props.stories.filter(story => {
          if (
            story.points.some(point => {
              return (
                point.properties["type_of_place"] &&
                point.properties["type_of_place"].toLowerCase() ===
                  item.toLowerCase()
              );
            })
          ) {
            return story;
          }
        });
        break;
      }
      case FILTER_CATEGORIES[2]: {
        // third category: speaker name
        filteredStories = this.props.stories.filter(story => {
          if (
            story.speakers.some(speaker => {
              return (
                speaker.name &&
                speaker.name.toLowerCase() === item.toLowerCase()
              );
            })
          ) {
            return story;
          }
        });
        break;
      }
      case FILTER_CATEGORIES[3]: {
        // second category: topic
        filteredStories = this.props.stories.filter(story => {
          if (
            story.points.some(point => {
              return (
                point.properties["topic"] &&
                point.properties["topic"].toLowerCase() ===
                  item.toLowerCase()
              );
            })
          ) {
            return story;
          }
        });
        break;
      }
    }
    if (filteredStories) {
      const filteredPoints = this.getPointsFromStories(filteredStories);
      const bounds = bbox(filteredPoints);
      const framedView = {
        bounds,
        maxZoom: 12
      };
      this.setState({
        stories: filteredStories,
        points: filteredPoints,
        framedView
      });
    }
  };

  handleFilterCategoryChange = option => {
    if (option === null) {
      this.resetStoriesAndMap();
    } else {
      const category = option.value;
      this.setState({ filterCategory: category, itemOptions: this.filterMap()[category] })
    }
  }

  handleFilterItemChange = option => {
    if (option === null) {
      this.resetStoriesAndMap();
    } else if (this.state.filterCategory !== null) {
      const item = option.value;
      this.handleFilter(this.state.filterCategory, item);
      this.setState({ filterItem: item });
    }
  }

  showMapPointStories = stories => {
    let storyTitles = stories.map(story => story.title);
    let filteredStories = [];
    filteredStories = this.props.stories.filter(story =>
      storyTitles.includes(story.title)
    );
    if (filteredStories) {
      this.setState({
        stories: filteredStories,
        activeStory: filteredStories[0]
      });
    }
  };

  handleStoriesChanged = stories => {
    this.setState({ stories: stories });
  };

  handleStoryClick = story => {
    // set active to first point in story
    const point = story.points[0];
    const framedView = { center: point.geometry.coordinates };
    this.setState({ activePoint: point, activeStory: story, framedView });
  };

  resetStoriesAndMap = () => {
    const points = this.getPointsFromStories(this.props.stories);
    this.setState({
      stories: this.props.stories,
      points: points,
      framedView: null,
      activePoint: null,
      activeStory: null,
      filterCategory: DEFAULT_CATEGORY_PLACEHOLDER,
      filterItem: DEFAULT_ITEM_PLACEHOLDER
    });
  };

  handleMapPointClick = (point) => {
    this.showMapPointStories(JSON.parse(point.properties.stories));
    const framedView = { center: point.geometry.coordinates };
    this.setState({ activePoint: point, framedView });
  };

  render() {
    return (
      <div>
        <Map
          points={this.state.points}
          mapboxAccessToken={this.props.mapbox_access_token}
          useLocalMapServer={this.props.use_local_map_server}
          mapboxStyle={this.props.mapbox_style}
          clearFilteredStories={this.resetStoriesAndMap}
          onMapPointClick={this.handleMapPointClick}
          activePoint={this.state.activePoint}
          framedView={this.state.framedView}
          markerImgUrl={this.props.marker_image_url}
          centerLat={this.props.center_lat}
          centerLong={this.props.center_long}
          zoom={this.props.zoom}
          sw_boundary_lat={this.props.sw_boundary_lat}
          sw_boundary_long={this.props.sw_boundary_long}
          ne_boundary_lat={this.props.ne_boundary_lat}
          ne_boundary_long={this.props.ne_boundary_long}
          pitch={this.props.pitch}
          bearing={this.props.bearing}
        />
        <Card
          activeStory={this.state.activeStory}
          stories={this.state.stories}
          handleStoriesChanged={this.handleStoriesChanged}
          categories={FILTER_CATEGORIES}
          filterMap={this.filterMap()}
          handleFilter={this.handleFilter}
          clearFilteredStories={this.resetStoriesAndMap}
          onStoryClick={this.handleStoryClick}
          logo_path={this.props.logo_path}
          user={this.props.user}
          filterCategory={this.state.filterCategory}
          filterItem={this.state.filterItem}
          handleFilterCategoryChange={this.handleFilterCategoryChange}
          handleFilterItemChange={this.handleFilterItemChange}
          itemOptions={this.state.itemOptions}
        />
        <IntroPopup />
      </div>
    );
  }
}
export default App;
