# frozen_string_literal: true

source 'https://rubygems.org'

gem 'jekyll', '~> 3.8.5'

group :jekyll_plugins do
  gem 'jekyll-admin'
  gem 'jekyll-assets'
  gem 'jekyll-autoprefixer'
  gem 'jekyll-coffeescript'
  gem 'jekyll-paginate-v2'
  gem 'normalize-scss'
end

group :test do
  gem 'rake'
end

gem 'rubocop', require: false
gem 'scss_lint', require: false

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Performance-booster for watching directories on Windows
gem 'wdm', '~> 0.1.0' if Gem.win_platform?
