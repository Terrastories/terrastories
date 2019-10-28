import React, { useState } from "react";
import Select from "react-select";
import PropTypes from "prop-types";

const Filter = props => {
  let DEFAULT_CATEGORY_PLACEHOLDER = I18n.t("select_category");
  let DEFAULT_ITEM_PLACEHOLDER = I18n.t("select_option");

  const [itemOptions, setItemOptions] = useState([]);
  const [categorySelectValue, setCategorySelectValue] = useState(
    DEFAULT_CATEGORY_PLACEHOLDER
  );
  const [itemSelectValue, setItemSelectValue] = useState(
    DEFAULT_ITEM_PLACEHOLDER
  );

  const handleCategoryChange = option => {
    if (option === null) {
      props.clearFilteredStories();
      setCategorySelectValue(DEFAULT_ITEM_PLACEHOLDER);
      setItemSelectValue(DEFAULT_ITEM_PLACEHOLDER);
    } else {
      const category = option.value;
      "Picked category ", category;
      setCategorySelectValue(category);
      setItemOptions(props.filterMap[category]);
      setItemSelectValue(DEFAULT_ITEM_PLACEHOLDER);
    }
  };

  const handleItemChange = option => {
    if (option === null) {
      props.clearFilteredStories();
      setItemSelectValue(DEFAULT_ITEM_PLACEHOLDER);
    } else {
      const item = option.value;
      props.handleFilter(categorySelectValue, item);
      setItemSelectValue(item);
    }
  };

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
        value={optionsHash([categorySelectValue])}
        onChange={handleCategoryChange}
        isClearable={categorySelectValue !== DEFAULT_CATEGORY_PLACEHOLDER}
        name="filter-categories"
        options={optionsHash(props.categories)}
      />
      <Select
        className="itemFilter"
        classNamePrefix="select"
        value={optionsHash([itemSelectValue])}
        onChange={handleItemChange}
        isClearable={itemSelectValue !== DEFAULT_ITEM_PLACEHOLDER}
        isSearchable={true}
        name="filter-items"
        options={optionsHash(itemOptions)}
      />
    </React.Fragment>
  );
};

Filter.propTypes = {
  categories: PropTypes.array,
  filterMap: PropTypes.object,
  clearFilteredStories: PropTypes.func,
  handleFilter: PropTypes.func
};

Filter.defaultProps = {
  categories: [],
  filterMap: {},
  clearFilteredStories: () => {}
};

export default Filter;
