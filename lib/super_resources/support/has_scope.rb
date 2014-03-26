module SuperResources
  module HasScope
    protected

    def end_of_nests
      respond_to?(:apply_scopes) ? apply_scopes(super) : super
    end
  end
end
