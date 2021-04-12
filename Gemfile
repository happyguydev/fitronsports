source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.0'

# Rails Gems
gem 'bootsnap', '>= 1.4.2', require: false
gem 'jbuilder', '~> 2.7'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.1' 
gem 'rails', '~> 6.0.3', '>= 6.0.3.2'
gem 'redis'
gem 'sidekiq'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 4.0'

# Auth Gems
gem 'devise'
gem 'devise_masquerade'
gem 'cancancan'

# Admin Gems
gem 'rails_admin'

# AR Gems
gem 'activerecord-pg_enum'
gem 'acts_as_list'
gem 'acts-as-taggable-on'
gem 'dry-validation'

# Services
gem 'carrierwave'
gem 'carrierwave-color'
gem 'fog-aws'
gem 'pdfkit'
gem 'wkhtmltopdf-binary'
gem 'docraptor'
gem 'aws-sdk-s3'

gem 'responders'
gem 'name_of_person'

# View Gems
gem 'draper'
gem 'wicked'
gem 'inline_svg'
gem 'serviceworker-rails'
gem 'simple_form'
gem 'vue-rails-form-builder'
gem 'elemental_components'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'dotenv-rails'
  gem 'annotate'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'listen', '~> 3.2'
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'rubocop-performance'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'factory_bot_rails'
  gem 'capybara', '>= 2.15'
  gem 'minitest-spec-rails'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

group :development, :test, :staging do
  gem 'faker'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
