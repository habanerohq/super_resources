module SuperResources
  module URLHelpers
    extend ActiveSupport::Concern

    included do
      helper_method :collection_path, :resource_path, :new_resource_path,
                    :edit_resource_path
    end

    protected

    def full_association_chain_symbols
      symbols_for_association_chain + [resource_instance_name]
    end

    def collection_route
      uncountable = (resource_collection_name == resource_instance_name)
      chain = symbols_for_association_chain + [ uncountable ?
        "#{resource_instance_name}_index" : resource_collection_name ]

      :"#{chain.join('_')}_url"
    end

    def resource_route
      :"#{full_association_chain_symbols.join('_')}_url"
    end

    def new_resource_route
      :"new_#{resource_route}"
    end

    def edit_resource_route
      :"edit_#{resource_route}"
    end

    def collection_url
      send(collection_route, *association_chain)
    end

    alias_method :collection_path, :collection_url

    def resource_url(object = resource)
      if object.persisted?
        send(resource_route, *(association_chain + [object]))
      else
        collection_url # probably a new action
      end
    end

    alias_method :resource_path, :resource_url

    def new_resource_url
      send(new_resource_route, *association_chain)
    end

    alias_method :new_resource_path, :new_resource_url

    def edit_resource_url(object = resource)
      send(edit_resource_route, *(association_chain + [object]))
    end

    alias_method :edit_resource_path, :edit_resource_url
  end
end
