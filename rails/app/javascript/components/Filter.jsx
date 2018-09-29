import React, { Component } from 'react';
import Select from 'react-select';

class Filter extends Component {

  DEFAULT_CATEGORY_PLACEHOLDER = 'Select Category';
  DEFAULT_ITEM_PLACEHOLDER = 'Select Option'

  constructor(props){
    super(props);
    this.state = {
      itemOptions: [],
      categorySelectValue: this.DEFAULT_CATEGORY_PLACEHOLDER,
      itemSelectValue: this.DEFAULT_ITEM_PLACEHOLDER
    };
  }

  static defaultProps = {
    categories: ['Region', 'Type of Place', 'Speaker']
  };

  handleCategoryChange = option => {
    if (option === null) {
      this.setState({
        itemOptions: [],
        categorySelectValue: this.DEFAULT_CATEGORY_PLACEHOLDER,
        itemSelectValue: this.DEFAULT_ITEM_PLACEHOLDER
      });
    } else {
      const category = option.value;
      const filterMap = {
        'Region': ['Kumiade', 'Tukumutu', 'Kwata Ede'],
        'Type of Place': ['Place 1', 'Place 2', 'Place 3'],
        'Speaker': ['Speaker 1', 'Speaker 2', 'Speaker 3', 'Speaker 4']
      }
      console.log('Picked category ', category);
      this.setState({
        categorySelectValue: category,
        itemOptions: filterMap[category],
        itemSelectValue: this.DEFAULT_ITEM_PLACEHOLDER
      });
    }
  }

  handleItemChange = option => {
    if (option === null) {
      this.setState({
        itemSelectValue: this.DEFAULT_ITEM_PLACEHOLDER
      })
    } else {
      const item = option.value;
      console.log(`Filter by ${this.state.categorySelectValue} : ${item}`);
      this.props.handleFilter(this.state.categorySelectValue, item);
      this.setState({
        itemSelectValue: item
      });
    }
  }
  
  optionsHash = options => {
    return options.map(option => {
      return {value: option, label: option};
    });
  }

  render() {
    return (
      <React.Fragment>
        <span className="card--nav-filter">Filter Stories: </span>
        <Select
          className="basic-single"
          classNamePrefix="select"
          value={this.optionsHash([this.state.categorySelectValue])}
          onChange={this.handleCategoryChange}
          isClearable={this.state.categorySelectValue !== this.DEFAULT_CATEGORY_PLACEHOLDER}
          name="filter-categories"
          options={this.optionsHash(this.props.categories)}
        />
        <Select
          className="basic-single"
          classNamePrefix="select"
          value={this.optionsHash([this.state.itemSelectValue])}
          onChange={this.handleItemChange}
          isClearable={this.state.itemSelectValue !== this.DEFAULT_ITEM_PLACEHOLDER}
          isSearchable={true}
          name="filter-items"
          options={this.optionsHash(this.state.itemOptions)}
        />
      </React.Fragment>
    );
  }
}

export default Filter;
