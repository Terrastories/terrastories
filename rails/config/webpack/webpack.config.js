// See the shakacode/shakapacker README and docs directory for advice on customizing your generateWebpackConfig.
const { generateWebpackConfig } = require('shakapacker')

// Be sure to reload your server if you make changes to this config.
const customConfig = {
  resolve: {
    extensions: ['.css']
  },
  output: {
    library: ['Terrastories', '[name]'],
    libraryTarget: 'var',
  }
}

module.exports = generateWebpackConfig(customConfig)