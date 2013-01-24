class CreateResources < ActiveRecord::Migration
  def change
    create_table :simple_resources do |t|
      t.string :type
      t.text :description    	
    end

    create_table :child_resources do |t|
      t.belongs_to :parent_resource
      t.text :description    	
    end

    create_table :parent_resources do |t|
      t.belongs_to :grandparent_resource
      t.text :description    	
    end

    create_table :grandparent_resources do |t|
      t.belongs_to :great_grandparent_resource
      t.text :description    	
    end
  
    create_table :great_grandparent_resources do |t|
      t.text :description    	
    end
  end
end
