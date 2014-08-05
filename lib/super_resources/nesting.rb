require 'super_resources/nest_class'

module SuperResources
  module Nesting
    extend ActiveSupport::Concern

    include Resources
    include Routing

    included do
      alias_method :parent, :outer

      helper_method :nesting, :with_nesting, :nesting_hash, :nests, :nest_to, :nest_or_resource, :outer, :parent
    end

    protected

    def collection
      memoize_collection { nest_content }
    end

    def resource
      memoize_resource { nest_content.send(finder_method, params[:id]) if resource? }
    end

    def build_resource(params={})
      memoize_resource { nest_content.build(params) }
    end

    def nested?
      nests.any?
    end

    def nest_to(s)
      with_nesting(nest_or_resource(s)).uniq
    end

    def nest_or_resource(s)
      nesting[s.to_sym] || (resource if resource_instance_name == s.to_s)
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

    def nests
      @nests ||= nesting.values
    end

    def nesting
      @nesting ||=
        Hash[
          nesting_hash.inject({}) do |n, (k, v)|
            n[nest_name(k)] = nest_for(nest_name(k), n.values.last)
            n
          end.to_a.reverse
        ]
    end

    def nest_name(id_symbol)
      id_symbol.to_s.gsub(/_id$/, '').to_sym
    end

    def nest_for(nest_name, inner=resource)
      g = guesses(nest_name, inner)

      (g.length == 1 ? g.first : best_class(g, inner)).try(:find, params["#{nest_name}_id"])
    end

    def guesses(nest_name, inner)
      klass = inner.try(:class) || resource_class

      nest_class.new(nest_name, klass, inner).guesses
    end

    def best_class(class_array, inner)
      r = (inner.present? ? inner.class.name.demodulize.underscore.pluralize : resource_collection_name).to_sym

      descendant_class(class_array.select { |c| c.reflections[r] })
    end

    def descendant_class(class_array)
      class_array.reduce { |m, i| m < i ? m : i }
    end

    def nest_class
      SuperResources::NestClass
    end

    def nesting_hash
      Hash[path_parameters.except(*excluded_params).to_a.reverse]
    end

    def excluded_params
      path_parameters.keys.reject { |k| k =~ /_id$/ }
    end
  end
end
