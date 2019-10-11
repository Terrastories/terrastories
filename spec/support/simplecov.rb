SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter

SimpleCov.start do
  coverage_dir 'tmp/coverage'

  add_filter '/db/'
  add_filter '/config/'
  add_filter '/dashboards/'
  add_filter '/spec/'

  add_group 'Channels', 'app/channels'
  add_group 'Controllers', 'app/controllers'
  add_group 'Fields', 'app/fields'
  add_group 'Helpers', 'app/helpers'
  add_group 'Jobs', 'app/jobs'
  add_group 'Mailers', 'app/mailers'
  add_group 'Models', 'app/models'
  add_group 'Policies', 'app/policies'
  add_group 'Libraries', 'lib/'

  track_files '{app,lib}/**/*.rb'
end
