Dummy::Application.routes.draw do
  resources :simple_resources
  resources :adapted_resources
  resources :my_adapted_resources

  resources :parent_resources do
	  resources :child_resources
  end

  resources :great_grandparent_resources do
	  resources :grandparent_resources do
		  resources :parent_resources do
			  resources :child_resources
		  end
	  end
  end

end
