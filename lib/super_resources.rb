module SuperResources
  extend ActiveSupport::Autoload

  autoload :Actions
  autoload :Controller
  autoload :Nesting
  autoload :NestClass
  autoload :Resources
  autoload :Routing
  autoload :URLHelpers
  autoload :Version

  autoload_under 'support' do
    autoload :Cancan
    autoload :Draper
    autoload :HasScope
  end
end

require 'super_resources/railtie' if defined?(Rails)
