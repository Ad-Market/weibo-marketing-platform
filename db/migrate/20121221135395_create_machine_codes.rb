# -*- encoding : utf-8 -*-
class CreateMachineCodes < ActiveRecord::Migration
  def up

	   create_table :machine_codes do |t|
	      t.string :code
	      t.references :member
	      t.timestamps
	   end
   

 end

 def down
    drop_table :machine_codes
 end
end
