
// Globally mock the `i18n` class that we get from the i18n-js gem
class I18nMock {
  t() {  }
}
global.I18n = new I18nMock()
