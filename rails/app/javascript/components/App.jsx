import React, { Component } from 'react';
import Map from './Map';
import Card from './Card';
import IntroPopup from './IntroPopup';


class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      coords: [],
      points: {}
    }
  }

  componentDidMount() {
    this.getPointsFromStories();
  }

  setPointCoords = coords => {
    this.setState({coords});
  }

  getPointsFromStories = () => {
    const {stories} = this.props;
    const points = stories.map(story => story.point);
    this.setState({points});
  }

  render() {
    return (
      <div>
        <Map points={this.state.points} pointCoords={this.state.coords}/>
        <Card stories={this.props.stories} onCardClick={this.setPointCoords} logo_path={this.props.logo_path}/>
        <IntroPopup />
      </div>
    );
  }
}
export default App;
