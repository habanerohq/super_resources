class GreatGrandparentResourcesController < ApplicationController
	def index
		super do
			collection.each do |r|
				r.description = 'We are all great grandparents'
				r.save
			end
		end
	end

	def show
		super do
			resource.description = 'I am a great grandparent'
		end
	end

	def new
		super do
			resource.description = 'I am becoming a new great grandparent'
		end
	end

	def edit
		super do
			resource.description = 'I am becoming a great grandparent again'
		end
	end

	def create
		super do
			resource.description = 'I am a new great grandparent'
		end
	end

	def update
		super do
			resource.description = 'I am a great grandparent again'
		end
	end

	def destroy
		super do
			@obituary = 'Here lies a dead great grandparent'
		end
	end
end
