module SuperResources
  module Controller
    extend ActiveSupport::Concern

    include Actions
    include Nesting
    include HasScope
    include URLHelpers
  end
end
