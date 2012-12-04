module SuperResources
  module Nesting
    extend ActiveSupport::Concern

    included do
      helper_method :association_chain
    end

    protected

    def collection
      @collection ||= end_of_association_chain
    end

    def resource
      @resource ||= end_of_association_chain.find(params[:id])
    end

    def build_resource
      @resource ||= end_of_association_chain.build(resource_params)
    end

    def nested?
      association_chain.any?
    end

    def end_of_association_chain
      association_chain.any? ? association_chain.last.send(resource_collection_name) : resource_class.scoped
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
      route.parts \
           .select { |p| p.to_s =~ %r(_id$) } \
           .map    { |p| p.to_s.gsub(/_id$/, '').to_sym }
    end

    def with_chain(object)
      association_chain + [ object ]
    end

    def route
      result = nil
      Rails.application.routes.router.recognize(request) do |route, matches, params|
        result = route 
      end

      result
    end
  end
end
