source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# default gems
gem 'rails', '~> 5.2.1', '>= 5.2.1.1' # Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'puma', '~> 3.11' # Use Puma as the app server
gem 'sass-rails', '~> 5.0' # Use SCSS for stylesheets
gem 'uglifier', '>= 1.3.0' # Use Uglifier as compressor for JavaScript assets
gem 'turbolinks', '~> 5' # Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'jbuilder', '~> 2.5' # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'bootsnap', '>= 1.1.0', require: false # Reduces boot times through caching; required in config/boot.rb

# add gems
gem 'activerecord-import' # ActiveRecord Bulk Insertion
gem 'kaminari' # ActiveRecord Paginator
gem 'pg' # Postgres Database
gem 'sidekiq' # Threading workers
gem 'http' # HTTP Client
gem 'colorize' # Colorize String
gem 'bootstrap', '~> 4.3.1' # Bootstrap 4
gem 'jquery-rails' # Jquery 3 for Bootstrap 4
gem 'simple_form' # Form Builder
gem 'devise' # User Authentication
gem 'font-awesome-sass', '~> 5.8.1' # Icon
gem 'ransack' # ActiveRecord searching
gem 'rubyzip', '>= 1.2.1' # Zip file
gem 'axlsx', git: 'https://github.com/randym/axlsx.git', ref: 'c8ac844' # Create excel file
gem 'axlsx_rails' # Render .xlsx

# defalut but useless gem
# gem 'sqlite3' # Use sqlite3 as the database for Active Record
# gem 'mini_racer', platforms: :ruby # See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'coffee-rails', '~> 4.2' # Use CoffeeScript for .coffee assets and views
# gem 'redis', '~> 4.0' # Use Redis adapter to run Action Cable in production
# gem 'bcrypt', '~> 3.1.7' # Use ActiveModel has_secure_password
# gem 'mini_magick', '~> 4.8' # Use ActiveStorage variant
# gem 'capistrano-rails', group: :development # Use Capistrano for deployment

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Debugger
  gem 'pry'
  gem 'pry-nav'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
