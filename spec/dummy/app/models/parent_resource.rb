class ParentResource < ActiveRecord::Base
	belongs_to :parent_resource, :class_name => 'GrandParentResource'
	has_many :child_resources 
end