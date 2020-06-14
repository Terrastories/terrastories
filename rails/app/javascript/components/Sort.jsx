import React, { Component } from 'react';
import Select from 'react-select';
import PropTypes from 'prop-types';

const SORT_CRITERIA = ['most_recent', 'alphabetical', 'reversed_alphabetical'];

class Sort extends Component {
  constructor(props){
    super(props);
    this.state = {
      sortSelectValue: SORT_CRITERIA[0]
    };
  }

  static propTypes = {
    stories: PropTypes.array,
    handleStoriesChanged: PropTypes.func
  };

  static defaultProps = {
    stories: [],
    handleStoriesChanged: () => {}
  };

  componentDidMount() {
    this.handleSort(this.option(this.state.sortSelectValue));
  }

  optionsHash = values => {
    return values.map(value => {
      return this.option(value);
    });
  }

  option = value => {
    return {value: value, label: I18n.t(value)};
  }

  handleSort = (option) => {
    this.setState({
      sortSelectValue: option.value
    });

    let sortedStories = [];

    switch (option.value) {
      case SORT_CRITERIA[0]: {
        // most recent
        sortedStories = this.props.stories.sort((story1, story2) => {
          if (story1.created_at < story2.created_at) {
            return 1;
          }

          if (story1.created_at > story2.created_at) {
            return -1;
          }

          return 0;
        });

        break;
      }
      case SORT_CRITERIA[1]: {
        sortedStories = this.props.stories.sort((story1, story2) => {
          if (story1.title > story2.title) {
            return 1;
          }

          if (story1.title < story2.title) {
            return -1;
          }

          return 0;
        });

        break;
      }
      case SORT_CRITERIA[2]: {
        sortedStories = this.props.stories.sort((story1, story2) => {
          if (story1.title < story2.title) {
            return 1;
          }

          if (story1.title > story2.title) {
            return -1;
          }

          return 0;
        });

        break;
      }
    }

    this.props.handleStoriesChanged(sortedStories);
  }

  render() {
    return (
      <React.Fragment>
        <span className="card--nav-sort">{I18n.t("sort_stories")}: </span>
        <Select
          className="storiesSort"
          classNamePrefix="select"
          name="sort-stories"
          onChange={this.handleSort}
          value={this.option(this.state.sortSelectValue)}
          options={this.optionsHash(SORT_CRITERIA)}
        />
      </React.Fragment>
    );
  }
}

export default Sort;
