class ParentResource < ActiveRecord::Base
	belongs_to :parent_resource, :class_name => 'GrandparentResource'
	has_many :child_resources 

	attr_accessible :parent_resource
end