class ChildResource < ActiveRecord::Base
	belongs_to :parent_resource

	attr_accessible :parent_resource
end