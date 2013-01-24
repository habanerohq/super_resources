class ParentResource < ActiveRecord::Base
	belongs_to :grandparent_resource
	has_many :child_resources 

	attr_accessible :grandparent_resource
end