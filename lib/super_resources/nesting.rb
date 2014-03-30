require 'super_resources/nest_resource'

module SuperResources
  module Nesting
    extend ActiveSupport::Concern

    include Resources
    include Routing

    included do
      alias_method :parent, :outer

      helper_method :nesting, :with_nesting, :nesting_hash, :nests, :outer, :parent
    end

    protected

    def collection
      memoize_collection { nest_content }
    end

    def resource
      memoize_resource { nest_content.send(finder_method, params[:id]) }
    end

    def build_resource(params={})
      memoize_resource { nest_content.build(params) }
    end

    def nested?
      nests.any?
    end

    def outer
      nests.last
    end

    def with_nesting(r)
      nests + [ r ]
    end

    def nest_content
      nested? ? outer.send(resource_collection_name.downcase) : resource_class.all
    end

    def nesting_hash
      path_parameters.except(:id, :action, :controller)
    end

    def nests
      @nests ||= nesting.values
    end

    def nesting
      @nesting ||=
        nesting_hash.inject({}) do |n, (k, v)|
          n[nest_name(k)] = nest_for(nest_name(k), n.values.last)
          n
        end
    end

    def nest_name(id_symbol)
      id_symbol.to_s.gsub(/_id$/, '').to_sym
    end

    def nest_for(nest_name, inner=resource)
      klass = inner.try(:class) || resource_class

      SuperResources::NestResource.new(nest_name, params["#{nest_name}_id"], klass, inner).resource
    end
  end
end
