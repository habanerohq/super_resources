module SuperResources
  module FriendlyId
    extend ActiveSupport::Concern

    protected

    def resource_finding(scope)
      # NOTE: only a handful of finder methods are provided by friendly_id, so
      #       provide some feedback if #finder_method would short-circuit
      unless friendly_finders.include?(finder_method.to_sym)
        raise NoMethodError.new("Unfriendly finder method `#{finder_method}'")
      end

      friendly?(scope) ? super : super(scope.friendly)
    end

    private

    def friendly?(klass = resource_class)
      klass.method(:find) \
           .owner == ::FriendlyId::FinderMethods
    end

    def friendly_finders
      @@friendly_finders ||=
        ::FriendlyId::FinderMethods.public_instance_methods
    end
  end
end
