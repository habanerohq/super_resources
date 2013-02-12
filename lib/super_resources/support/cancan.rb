module SuperController
  module Cancan
    extend ActiveSupport::Concern

    def index(*args)
      authorize! :index, resource_class
      super
    end

    def show(*args)
      authorize! :show, resource
      super
    end

    def new(*args)
      authorize! :new, resource_class
      super
    end

    def edit(*args)
      authorize! :edit, resource
      super
    end

    def create(*args)
      authorize! :create, resource_class
      super
    end

    def update(*args)
      authorize! :update, resource
      super
    end

    def destroy(*args)
      authorize! :destroy, resource
      super
    end

    protected

    def collection
      super.accessible_by(current_ability)
    end
  end
end
