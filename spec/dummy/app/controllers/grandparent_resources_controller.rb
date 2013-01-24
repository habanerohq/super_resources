class GrandparentResourcesController < ApplicationController
	def create
		super :location => polymorphic_url(parent)
	end

	def update
		super :location => polymorphic_url(parent)
	end

	def destroy
		super :location => polymorphic_url(parent)
	end
end
