module SuperResources
  module Resources
    extend ActiveSupport::Concern

    included do
      helper_method :collection, :resource
    end

    protected

    def resource_class
      controller_name.classify.singularize.safe_constantize
    end

    def resource_instance_name
      resource_class.name.underscore.to_sym
    end

    def resource_collection_name
      resource_instance_name.to_s.pluralize.to_sym
    end

    def collection
      @collection ||= resource_class.scoped
    end

    def resource
      @resource ||= resource_class.find(params[:id])
    end

    def build_resource
      @resource ||= resource_class.new(resource_params)
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
