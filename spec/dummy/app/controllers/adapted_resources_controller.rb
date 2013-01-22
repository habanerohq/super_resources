class AdaptedResourcesController < SimpleResourcesController

  protected

  def resource_class
  	MyAdaptedResource
  end

  def resource_params_name
    :input
  end

  def build_resource
   	super do
      resource_class.new do |p|
         p.description = a_hard_coded_description
    	end
    end
  end

  def a_hard_coded_description
  	'We hard-coded this description in AdaptedResourcesController#build_resource'
  end
end
