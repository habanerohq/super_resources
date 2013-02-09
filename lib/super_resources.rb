module SuperResources
  extend ActiveSupport::Autoload

  autoload :Actions
  autoload :Controller
  autoload :Nesting
  autoload :Resources
  autoload :URLHelpers
  autoload :Version

  autoload_under 'support' do
    autoload :HasScope
    autoload :Cancan
  end
end

require 'super_resources/railtie' if defined?(Rails)
