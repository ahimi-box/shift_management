source 'https://rubygems.org'

ruby '2.6.6'
gem 'rails',        '~> 5.1.6'
gem 'rails-i18n'
gem 'bcrypt'
gem 'faker'
gem 'bootstrap-sass'
gem 'will_paginate'
gem 'bootstrap-will_paginate'
gem 'puma',         '~> 3.7'
# gem 'sass-rails',   '~> 5.0'
gem 'sass-rails',   '~> 6'
gem 'uglifier',     '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks',   '~> 5'
gem 'jbuilder',     '~> 2.5'
gem 'rounding'
# ↓アップする時コメントにする
gem 'sqlite3'

#カレンダー
gem 'simple_calendar', '~> 2.0'

# グラフ
gem 'chartkick'

gem 'byebug'
gem 'roo'

gem 'devise'
gem 'devise-i18n'
gem 'devise-i18n-views'

# LINEログイン
gem 'omniauth-line'
gem 'dotenv-rails'
gem "omniauth-rails_csrf_protection"
# googleログイン
gem 'omniauth-google-oauth2'


group :development, :test do
  gem 'sqlite3'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# group :production do
#   gem 'pg', '0.20.0'
# end

# Windows環境ではtzinfo-dataというgemを含める必要があります
# Mac環境でもこのままでOKです
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
