class GrandparentResource < ActiveRecord::Base
	belongs_to :parent_resource, :class_name => 'GreatGrandparentResource'
	has_many :child_resources, :class_name => 'ParentResource'  
end