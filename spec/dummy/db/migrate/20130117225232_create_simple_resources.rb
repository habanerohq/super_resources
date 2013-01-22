class CreateSimpleResources < ActiveRecord::Migration
  def change
    create_table :simple_resources do |t|
      t.string :type
      t.text :description    	
    end
  end
end
