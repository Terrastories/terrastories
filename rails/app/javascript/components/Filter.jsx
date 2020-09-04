import React, { useState } from "react";
import Select from "react-select";
import PropTypes from "prop-types";

const Filter = props => {
  let DEFAULT_CATEGORY_PLACEHOLDER = I18n.t("select_category");
  let DEFAULT_ITEM_PLACEHOLDER = I18n.t("select_option");

  const handleCategoryChange = option => props.handleFilterCategoryChange(option);

  const handleItemChange = option => props.handleFilterItemChange(option);

  const optionsHash = options => {
    return options.map(option => {
      return { value: option, label: option };
    });
  };

  return (
    <React.Fragment>
      <span className="card--nav-filter">{I18n.t("filter_stories")}: </span>
      <Select
        className="categoryFilter"
        classNamePrefix="select"
        value={optionsHash([props.filterCategory])}
        onChange={handleCategoryChange}
        isClearable={props.filterCategory !== DEFAULT_CATEGORY_PLACEHOLDER}
        name="filter-categories"
        options={optionsHash(props.categories)}
      />
      <Select
        className="itemFilter"
        classNamePrefix="select"
        value={optionsHash([props.filterItem])}
        onChange={handleItemChange}
        isClearable={props.filterItem !== DEFAULT_ITEM_PLACEHOLDER}
        isSearchable={true}
        name="filter-items"
        options={optionsHash(props.itemOptions)}
      />
    </React.Fragment>
  );
};

Filter.propTypes = {
  categories: PropTypes.array,
  filterMap: PropTypes.object,
  clearFilteredStories: PropTypes.func,
  handleFilterCategoryChange: PropTypes.func,
  handleFilterItemChange: PropTypes.func,
  itemOptions: PropTypes.array
};

Filter.defaultProps = {
  categories: [],
  filterMap: {},
  clearFilteredStories: () => {}
};

export default Filter;
