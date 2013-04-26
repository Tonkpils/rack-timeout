# encoding: utf-8
require_relative 'rack/timeout'

if defined?(Rails) && [3,4].include?(Rails::VERSION::MAJOR)
  class Rack::Timeout::Railtie < Rails::Railtie
    initializer('rack-timeout.insert-rack-timeout') { |app| app.config.middleware.insert 0, Rack::Timeout }
  end
end
