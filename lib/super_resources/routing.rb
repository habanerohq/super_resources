module SuperResources
  module Routing
    extend ActiveSupport::Concern

    protected

    def routes
      Rails.application.routes || request.env['action_dispatch.routes']
    end

    def router
      routes.router
    end

    def route
      @route ||= recognize_route(request.path.present? ? request : mock_request)
    end

    private

    def recognize_route(request)
      router.recognize(request) do |route, matches, params|
        return route
      end
    end

    def path_parameters
      request.env['action_dispatch.request.path_parameters'].symbolize_keys
    end

    def mock_request
      # used when there's no path in +request+. only seems to happen when
      # testing controller actions
      @mock_request ||= begin
        env = Rack::MockRequest.env_for(url_for(path_parameters), :method => request.method)
        request.class.new(env)
      end
    end
  end
end
