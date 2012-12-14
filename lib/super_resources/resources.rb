module SuperResources
  module Resources
    extend ActiveSupport::Concern

    included do
      helper_method :collection, :collection=, :resource, :resource=, :resource_class, :parent, :nested?
    end

    protected

    def resource_class
      controller_name.classify.singularize.safe_constantize
    end

    def resource_instance_name
      controller_name.singularize.to_sym
    end

    def resource_collection_name
      controller_name.to_sym
    end

    def collection(&block)
      if block_given?
        @collection = yield
      else
        @collection ||= resource_class.scoped
      end
    end

    def collection=(c)
      @collection = c
    end

    def resource(&block)
      case
      when block_given?
        @resource = yield
      when params[:id].present?      
        @resource ||= resource_class.send(finder_method, params[:id])
      else
        build_resource
      end
    end

    def resource=(r)
      @resource = r
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

    def build_resource(&block)
      if block_given?
        @resource = yield
      else
        @resource ||= resource_class.new(resource_params)
      end
    end

    def create_resource(attributes)
      build_resource.attributes = attributes
      resource.save
    end

    def update_resource(attributes)
      resource.update_attributes(attributes)
    end
  
    def resource_params
      params[resource_instance_name] || {}
    end

    def destroy_resource
      resource.destroy
    end
  end
end
