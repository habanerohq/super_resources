module SuperResources
  module Controller
    extend ActiveSupport::Concern

    included do
    	include Actions
	    include Nesting
	    include HasScope
	    include URLHelpers	    
	  end
  end
end
