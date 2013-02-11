class GreatGrandparentResourcesController < ApplicationController
	def index
		super.tap do
			collection.each do |r|
				r.description = 'We are all great grandparents'
				r.save
			end
		end
	end

	def show
		super.tap do
			resource.description = 'I am a great grandparent'
		end
	end

	def new
		super.tap do
			resource.description = 'I am becoming a new great grandparent'
		end
	end

	def edit
		super.tap do
			resource.description = 'I am becoming a great grandparent again'
		end
	end

	def create
		super.tap do
			resource.description = 'I am a new great grandparent'
		end
	end

	def update
		super.tap do
			resource.description = 'I am a great grandparent again'
		end
	end

	def destroy
		super.tap do
			@obituary = 'Here lies a dead great grandparent'
		end
	end
end
