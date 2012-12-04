module SuperResources
  module Controller
    extend ActiveSupport::Concern

    include Actions
    include Resources
    include Nesting
    include URLHelpers
  end
end
