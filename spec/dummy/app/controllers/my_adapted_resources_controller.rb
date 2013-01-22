class MyAdaptedResourcesController < AdaptedResourcesController

  protected

  def finder_method
  	:find_by_description
  end
end
