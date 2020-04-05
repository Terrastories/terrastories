$LOAD_PATH.push(File.join(File.dirname(__FILE__), '..', '..'))

require 'capybara'
require 'capybara/cucumber'
require 'selenium-webdriver'
require 'site_prism'
require 'site_prism/all_there'
require 'capybara-screenshot/cucumber'
require 'byebug'

Capybara.app_host = "http://#{ENV['TEST_APP_HOST']}:#{ENV['TEST_APP_PORT']}"
Capybara.default_driver = :selenium
Capybara.javascript_driver = :selenium
Capybara.run_server = false

# Configure the Chrome driver capabilities & register
args = ['--no-default-browser-check', '--start-maximized']
caps = Selenium::WebDriver::Remote::Capabilities.chrome("chromeOptions" => {"args" => args})
Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(
      app,
      browser: :remote,
      url: "http://#{ENV['SELENIUM_HOST']}:#{ENV['SELENIUM_PORT']}/wd/hub",
      desired_capabilities: caps
  )
end

module CucumberGlobalMethods
  def app
    @app ||= App.new
  end
end
World(CucumberGlobalMethods)

require 'app'