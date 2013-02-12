module SuperResources
  module Draper
    extend ActiveSupport::Concern

    protected

    def decorator_class
      resource_class.decorator_class
    end

    def resource
      memoize_resource { decorator_class.decorate(super) }
    end

    def collection
      memoize_collection { decorator_class.decorate_collection(super) }
    end

    def build_resource
      memoize_resource { decorator_class.decorate(super) }
    end
  end
end
