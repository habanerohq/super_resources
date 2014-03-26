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
      @nests ||= nesting.values.reverse
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

      case

      when (r = klass.reflections[nest_name].present?)
        resource_for_reflection(nest_name, r)

      when (r = klass.reflections.values.detect { |r| nest_name.to_s.in?(r.class_name.underscore) })
        resource_for_reflection(nest_name, r)

      when (r = klass.reflections.values.detect { |r| nest_name.to_s.include?(r.class_name.underscore.split('/').last) })
        resource_for_reflection(nest_name, r)

      else
        r = klass.reflections.values.select { |r| r.macro == :belongs_to }.detect do |r|
          n = inner.send(r.name)
          nest_name.to_s.in?(n.class.name.underscore)
        end
      end
      resource_for_reflection(nest_name, r)
    end

    def resource_for_reflection(nest_name, reflection)
      reflection.class_name.safe_constantize.find(params["#{nest_name}_id"])
    end
  end
end
