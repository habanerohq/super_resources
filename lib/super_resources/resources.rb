module SuperResources
  module Resources
    extend ActiveSupport::Concern

    included do
      helper_method :collection, :collection?, :resource, :resource?,
                    :resource_class, :parent, :nested?
    end

    protected

    def resource_class
      controller_name.classify.singularize.safe_constantize
    end

    def resource_instance_name
      controller_name.singularize.to_sym
    end

    def resource_params_name
      resource_instance_name
    end

    def resource_collection_name
      controller_name.to_sym
    end

    def collection
      memoize_collection { resource_class.scoped }
    end

    def memoize_collection(&block)
      @collection ||= block.call
    end

    def collection?
      not resource?
    end

    def resource
      memoize_resource { resource_class.send(finder_method, params[:id]) }
    end

    def memoize_resource(&block)
      @resource ||= block.call
    end

    def resource?
      params[:id].present?
    end

    def finder_method
      :find
    end

    def nested?
      false
    end

    def parent
      nil
    end

    def resource_params
      params[resource_params_name] || {}
    end

    def build_resource(params={})
      memoize_resource { resource_class.new(params) }
    end

    def create_resource(params)
      build_resource(params).save
    end

    def update_resource(params)
      resource.update_attributes(params)
    end

    def destroy_resource
      resource.destroy
    end

    def method_missing(method, *args, &block)
      method == resource_instance_name ? resource : super
    end
  end
end
