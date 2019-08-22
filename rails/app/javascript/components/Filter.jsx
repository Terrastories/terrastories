import React, { Component } from "react";
import Select from "react-select";
import PropTypes from "prop-types";

class Filter extends Component {
	DEFAULT_CATEGORY_PLACEHOLDER = I18n.t("select_category");
	DEFAULT_ITEM_PLACEHOLDER = I18n.t("select_option");

	constructor(props) {
		super(props);
		this.state = {
			itemOptions: [],
			categorySelectValue: this.DEFAULT_CATEGORY_PLACEHOLDER,
			itemSelectValue: this.DEFAULT_ITEM_PLACEHOLDER
		};
	}

	static propTypes = {
		categories: PropTypes.array,
		filterMap: PropTypes.object,
		clearFilteredStories: PropTypes.func,
		handleFilter: PropTypes.func
	};

	static defaultProps = {
		categories: [],
		filterMap: {},
		clearFilteredStories: () => {}
	};

	handleCategoryChange = option => {
		if (option === null) {
			this.props.clearFilteredStories();
			this.setState({
				itemOptions: [],
				categorySelectValue: this.DEFAULT_CATEGORY_PLACEHOLDER,
				itemSelectValue: this.DEFAULT_ITEM_PLACEHOLDER
			});
		} else {
			const category = option.value;
			"Picked category ", category;
			this.setState({
				categorySelectValue: category,
				itemOptions: this.props.filterMap[category],
				itemSelectValue: this.DEFAULT_ITEM_PLACEHOLDER
			});
		}
	};

	handleItemChange = option => {
		if (option === null) {
			this.props.clearFilteredStories();
			this.setState({
				itemSelectValue: this.DEFAULT_ITEM_PLACEHOLDER
			});
		} else {
			const item = option.value;
			this.props.handleFilter(this.state.categorySelectValue, item);
			this.setState({
				itemSelectValue: item
			});
		}
	};

	optionsHash = options => {
		return options.map(option => {
			return { value: option, label: option };
		});
	};

	render() {
		return (
			<React.Fragment>
				<span className="card--nav-filter">{I18n.t("filter_stories")}: </span>
				<Select
					className="categoryFilter"
					classNamePrefix="select"
					value={this.optionsHash([this.state.categorySelectValue])}
					onChange={this.handleCategoryChange}
					isClearable={
						this.state.categorySelectValue !== this.DEFAULT_CATEGORY_PLACEHOLDER
					}
					name="filter-categories"
					options={this.optionsHash(this.props.categories)}
				/>
				<Select
					className="itemFilter"
					classNamePrefix="select"
					value={this.optionsHash([this.state.itemSelectValue])}
					onChange={this.handleItemChange}
					isClearable={
						this.state.itemSelectValue !== this.DEFAULT_ITEM_PLACEHOLDER
					}
					isSearchable={true}
					name="filter-items"
					options={this.optionsHash(this.state.itemOptions)}
				/>
			</React.Fragment>
		);
	}
}

export default Filter;
