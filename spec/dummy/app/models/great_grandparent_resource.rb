class GreatGrandparentResource < ActiveRecord::Base
	has_many :child_resources, :class_name => 'GrandparentResource'
end