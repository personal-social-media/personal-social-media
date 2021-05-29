# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

is_dev = !ENV["DEVELOPER"].nil?

ruby "3.0.1"
gem "bcrypt", "~> 3.1.7"
gem "bootsnap", ">= 1.4.4", require: false
gem "pg", "~> 1.2", ">= 1.2.3"
gem "rails", "~> 6.1.3", ">= 6.1.3.2"
gem "sass-rails", ">= 6"
gem "turbolinks", "~> 5.2", ">= 5.2.1"
gem "webpacker", "~> 6.0.0.beta.7"

group :development do
  gem "listen", "~> 3.5", ">= 3.5.1"
  gem "spring"
end
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# End default rails

group :development do
  gem "annotate", "~> 3.1", ">= 3.1.1"
  gem "better_errors", "~> 2.9", ">= 2.9.1"
  gem "binding_of_caller", "~> 1.0"
  gem "foreman", "~> 0.87.2"
  gem "guard", "~> 2.16", ">= 2.16.2"
  gem "guard-livereload", "~> 2.5", ">= 2.5.2"
  gem "puma", "~> 5.3", ">= 5.3.1"
  gem "rack-livereload", "~> 0.3.17"
  gem "rubocop-rails_config", "~> 1.5", ">= 1.5.3"
end

group :development, :test do
  gem "brakeman", "~> 5.0", ">= 5.0.1"
  gem "bundler-audit"
  gem "dotenv-rails", "~> 2.7", ">= 2.7.6"
  gem "erb_lint", require: false
  gem "factory_bot_rails", "~> 6.2"
  gem "ffaker", "~> 2.18"
  gem "pry-rails", "~> 0.3.9"
  gem "rspec-rails", "~> 5.0", ">= 5.0.1"
  gem "spring-commands-rspec", "~> 1.0", ">= 1.0.4"
end

group :test do
  gem "capybara", "~> 3.35", ">= 3.35.3"
  gem "database_cleaner-active_record", "~> 2.0", ">= 2.0.1"
  gem "vcr", "~> 6.0"
  gem "webmock"
end

group :test, :production do
  gem "falcon", "~> 0.38.1"
end

gem "attributes_sanitizer", "~> 0.1.6"
gem "bitwise_attribute"
gem "bugsnag", "~> 6.20", require: is_dev
gem "email_validator", "~> 2.2", ">= 2.2.3"
gem "hcaptcha", github: "personal-social-media/hcaptcha", ref: "a2135327e0f22ddba170d77dbba86827cd05c2cb"
gem "hiredis", "~> 0.6.3", require: %w(redis redis/connection/hiredis)
gem "jb", "~> 0.8.0"
gem "lockbox", "~> 0.6.4"
gem "oj", "~> 3.11", ">= 3.11.5"
gem "rails_admin", "~> 2.1", ">= 2.1.1", require: is_dev
gem "rbnacl", "~> 7.1", ">= 7.1.1"
gem "rmega", github: "personal-social-media/rmega", ref: "bc1ffc624cfb30197fea1b042ff1115961ad89f5"
gem "sidekiq", "~> 6.2", ">= 6.2.1", require: %w(sidekiq/web)
gem "sidekiq-cron", "~> 1.2", require: %w(sidekiq/cron/web)
gem "sidekiq-throttled", "~> 0.13.0", require: "sidekiq/throttled"
gem "str_enum", "~> 0.2.0"
gem "strong_migrations", "~> 0.7.6"
gem "typhoeus", "~> 1.4"
gem "validates_host", "~> 1.3"
gem "view_component", require: "view_component/engine"
