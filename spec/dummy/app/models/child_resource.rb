class ChildResource < ActiveRecord::Base
	belongs_to :parent_resource
end