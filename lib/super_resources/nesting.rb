module SuperResources
  module Nesting
    extend ActiveSupport::Concern
    include Resources

    included do
      helper_method :association_chain, :with_chain, :method_missing, :respond_to?
    end

    def respond_to?(m, *args)
      m.in?(symbols_for_association_chain) ? true : super
    end

    protected

    def method_missing(m, *args, &block)
      case
      when m == resource_params_name
        resource
      when i = symbols_for_association_chain.index(m)
        association_chain[i]
      else
        super
      end
    end

    def collection(&block)
      if block_given?
        @collection = yield
      else
        @collection ||= end_of_association_chain
      end
    end

    def resource(&block)
      if block_given?
        @resource = yield
      else
        @resource ||= end_of_association_chain.send(finder_method, params[:id])
      end
    end

    def build_resource(&block)
      if block_given?
        @resource = yield
      else
        @resource ||= end_of_association_chain.build(resource_params)
      end
    end

    def nested?
      association_chain.any?
    end

    def parent
      association_chain.last
    end

    def end_of_association_chain
      nested? ? parent.send(resource_collection_name) : resource_class.scoped
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
      pp route
      @symbols_for_association_chain ||=
        route.parts \
             .select { |p| p.to_s =~ %r(_id$) } \
             .map    { |p| p.to_s.gsub(/_id$/, '').to_sym }
      @symbols_for_association_chain
    end

    def with_chain(object)
      association_chain + [ object ]
    end

    def route
      @route ||= begin
        routes.formatter.send(:match_route, nil, path_parameters) do |route|
          # TODO: don't assume the first route is good, validate!
          # TODO: don't use break
          break route
        end
      end
    end

    def routes
      request.env['action_dispatch.routes']
    end

    def path_parameters
      request.env['action_dispatch.request.path_parameters']
    end
  end
end
