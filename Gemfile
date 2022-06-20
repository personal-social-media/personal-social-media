# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }
is_redis_enabled = !ENV["REDIS_URL"].nil?

is_dev = false
if ENV["RAILS_ENV"] != "production"
  is_dev = true
elsif ENV["DEVELOPER"]
  is_dev = true
end

ruby "3.0.3"
gem "bcrypt", "~> 3.1.7"
gem "bootsnap", ">= 1.4.4", require: false
gem "pg", "~> 1.2", ">= 1.2.3"
gem "rails", "~> 6.1.4"
gem "sass-rails", ">= 6"
gem "turbolinks", "~> 5.2", ">= 5.2.1"
gem "webpacker", git: "https://github.com/rails/webpacker.git"

group :development do
  gem "listen", "~> 3.6"
  gem "spring"
end
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# End default rails

group :development do
  gem "annotate", "~> 3.1", ">= 3.1.1"
  gem "better_errors", "~> 2.9", ">= 2.9.1"
  gem "binding_of_caller", "~> 1.0"
  gem "foreman", "~> 0.87.2"
  gem "lefthook", "~> 0.7.6"
  gem "memory_profiler"
  gem "puma", "~> 5.3"
  gem "rack-mini-profiler", "~> 2.3", ">= 2.3.2"
  gem "rubocop-rails_config", "~> 1.6"
  gem "stackprof"
end

group :development, :test do
  gem "brakeman", "~> 5.1"
  gem "bundler-audit"
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
  gem "falcon", "~> 0.39.2"
end

group :production do
  gem "skylight", "~> 5.1", ">= 5.1.1", require: is_dev
end

group :development, :production do
  gem "rails_performance", "~> 1.0", ">= 1.0.1", require: is_redis_enabled
end

gem "activeadmin", "~> 2.9"
gem "activeadmin-searchable_select", "~> 1.5"
gem "active_material", "~> 1.5", ">= 1.5.2"
gem "attributes_sanitizer", "~> 0.1.6"
gem "aws-sdk-s3", "~> 1.97"
gem "bitwise_attribute", github: "personal-social-media/bitwise_attribute", ref: "36371f6511a5907d1ec96385e0baca55d935cb99"
gem "bugsnag", "~> 6.21", require: is_dev
gem "bullet", "~> 6.1", ">= 6.1.4", require: is_dev
gem "dotenv-rails", "~> 2.7", ">= 2.7.6"
gem "draper", "~> 4.0", ">= 4.0.2"
gem "email_validator", "~> 2.2", ">= 2.2.3"
gem "exif", "~> 2.2", ">= 2.2.1"
gem "hash_digest", "~> 1.1", ">= 1.1.3"
gem "hcaptcha", github: "personal-social-media/hcaptcha", ref: "a2135327e0f22ddba170d77dbba86827cd05c2cb"
gem "hiredis", "~> 0.6.3", require: %w(redis redis/connection/hiredis)
gem "image_processing", "~> 1.12", ">= 1.12.1", require: "image_processing/vips"
gem "jb", "~> 0.8.0"
gem "lockbox", "~> 0.6.5"
gem "oj", "~> 3.12"
gem "pghero", "~> 2.8", ">= 2.8.1", require: is_dev
gem "pg_query", "~> 2.1", require: is_dev
gem "rails_admin", "~> 2.2", require: is_dev

gem "pg_search", "~> 2.3", ">= 2.3.5"
gem "rails-server-monitor", github: "personal-social-media/rails-server-monitor", require: "rails_server_monitor"
gem "rbnacl", "~> 7.1", ">= 7.1.1"
gem "react-rails", "~> 2.6", ">= 2.6.1"
gem "redcarpet", "~> 3.5", ">= 3.5.1"
gem "render_async", "~> 2.1", ">= 2.1.10"
gem "request_store", "~> 1.5"
gem "request_store_rails-sidekiq", "~> 0.1.0"
gem "rmega", github: "personal-social-media/rmega", ref: "007041cb4d568f430cd8e385d86da1d20a86ac42"
gem "schmooze", "~> 0.2.0"
gem "sidekiq", "~> 6.2", ">= 6.2.1", require: %w(sidekiq/web)
gem "sidekiq-cron", "~> 1.2", require: %w(sidekiq/cron/web)
gem "sidekiq-throttled", "~> 0.16.1", require: "sidekiq/throttled"
gem "str_enum", "~> 0.2.0"
gem "strong_migrations", "~> 0.7.7"
gem "typhoeus", "~> 1.4"
gem "unicode-emoji", "~> 2.8"
gem "validates_host", "~> 1.3"
gem "view_component"
