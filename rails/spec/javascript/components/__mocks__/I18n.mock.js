let currentLocale = jest.fn().mockImplementation(
    /**
        * Mocks currentLocale getter
        * @function
        * @return {String} the current locale
        */
    () => { return locale }
);

let translate = jest.fn().mockImplementation(
    /**
        * Mocks translate function
        * @function
        * @param {String} name the name of the translated string
        * @param {Object} options translation options
        * @param {String} options.locale the desired locale for translation
        * @returns {String} 
        */
    (name, options) => {
        let locale = "local translation";
        if (options && typeof(options.locale) == "string") {locale = options.locale}
        if (typeof(name) != "string" || name == "") {name = "\"\""}
        return name + " in " + locale;
    }
)

export { currentLocale, translate, translate as t };