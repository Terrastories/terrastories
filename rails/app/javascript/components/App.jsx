import React, { Component } from 'react';
import Map from './Map';
import Card from './Card';
import IntroPopup from './IntroPopup';


class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      coords: []
    }
  }

  setPointCoords = coords => {
    this.setState({coords});
  }

  render() {
    return (
      <div>
        <Map pointCoords={this.state.coords}/>
        <Card stories={this.props.stories} onCardClick={this.setPointCoords}/>
        <IntroPopup />
      </div>
    );
  }
}
export default App;