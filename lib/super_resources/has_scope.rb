module SuperResources
  module HasScope
    protected

    def end_of_association_chain
      respond_to?(:apply_scopes) ? apply_scopes(super) : super
    end
  end
end
