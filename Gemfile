source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.9'
gem 'bcrypt', '~> 3.1.7'
gem 'seed-fu', '~> 2.3.5'

gem 'actionpack-action_caching'

gem 'mail', '~> 2.5.4'

gem 'hiredis'
gem 'redis', require:  ["redis", "redis/connection/hiredis"]

gem 'pg'
gem 'redcarpet'
gem 'liquid'
gem 'activemerchant'
gem 'stripe', :git => 'https://github.com/stripe/stripe-ruby'

gem 'aws-sdk' # S3 API
gem 's3_direct_upload' # direct upload form helper and assets

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
gem 'bootstrap-sass'
gem 'therubyracer'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
gem "sentry-raven"

# Use debugger
# gem 'debugger', group: [:development, :test]
group :test do
  gem 'minitest-reporters', '1.0.5'
  gem 'mini_backtrace',     '0.1.3'
  gem 'guard-minitest',     '2.3.1'
end

group :production do
  gem 'rails_12factor', '0.0.2'
end
  