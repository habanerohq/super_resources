module SuperResources
  module Actions
    extend ActiveSupport::Concern

    included do
      respond_to :html
    end

    def index(options = {}, &block)
      respond_with(*(with_nesting(collection) << options), &block)
    end

    def show(options = {}, &block)
      respond_with(*(with_nesting(resource) << options), &block)
    end

    def new(options = {}, &block)
      respond_with(*(with_nesting(build_resource) << options), &block)
    end

    def edit(options = {}, &block)
      respond_with(*(with_nesting(resource) << options), &block)
    end

    def create(options = {}, &block)
      if create_resource(resource_params)
        options[:location] ||= resource_url
      end

      respond_with(*(with_nesting(resource) << options), &block)
    end

    def update(options = {}, &block)
      if update_resource(resource_params)
        options[:location] ||= resource_url
      end

      respond_with(*(with_nesting(resource) << options), &block)
    end

    def destroy(options = {}, &block)
      if destroy_resource
        options[:location] ||= collection_url
      end

      respond_with(*(with_nesting(resource) << options), &block)
    end
  end
end
