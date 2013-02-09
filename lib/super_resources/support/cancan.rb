module SuperController
  module Cancan
    extend ActiveSupport::Concern

    included do
      before_filter :authorize_resource
    end

    protected

    def authorize_resource
      #authorize! action_name.to_sym, resource
    end
  end
end
