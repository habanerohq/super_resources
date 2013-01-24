class GreatGrandparentResource < ActiveRecord::Base
	has_many :grandparent_resources
end