class GrandparentResource < ActiveRecord::Base
	belongs_to :great_grandparent_resource
	has_many :parent_resources

	attr_accessible :great_grandparent_resource
end