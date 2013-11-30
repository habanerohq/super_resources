module SuperResources
  module Nesting
    extend ActiveSupport::Concern

    include Resources
    include Routing

    included do
      helper_method :association_chain, :with_chain, :method_missing, :respond_to?
    end

    def respond_to?(m, *args)
      m.in?(symbols_for_association_chain) ? true : super
    end

    protected

    def collection
      memoize_collection { end_of_association_chain }
    end

    def resource
      memoize_resource { end_of_association_chain.send(finder_method, params[:id]) }
    end

    def build_resource(params={})
      memoize_resource { end_of_association_chain.build(params) }
    end

    def nested?
      association_chain.any?
    end

    def parent
      association_chain.last
    end

    def end_of_association_chain
      nested? ? parent.send(resource_collection_name.downcase) : resource_class.all
    end

    def association_chain
      @association_chain ||=
        symbols_for_association_chain.inject([]) do |chain, symbol|
          chain << chain_link(symbol, chain.last)
        end
    end

    def chain_link(symbol, previous_link)
      link = if previous_link
        previous_link.send(symbol.to_s.pluralize.to_sym)
      else
        symbol.to_s.classify.safe_constantize
      end

      link.find(params[:"#{symbol}_id"])
    end

    def symbols_for_association_chain
      @symbols_for_association_chain ||=
        route.parts \
             .select { |p| p.to_s =~ %r(_id$) } \
             .map    { |p| p.to_s.gsub(/_id$/, '').to_sym }
    end

    def with_chain(object)
      association_chain + [ object ]
    end

    def method_missing(method, *args, &block)
      if index = symbols_for_association_chain.index(method)
        association_chain[index]
      else
        super
      end
    end
  end
end
