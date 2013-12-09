class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, :id => false, :primary_key => :uid do |t|
      t.integer :uid, :limit => 8
      t.integer :province
      t.integer :city
      t.string :v
      t.integer :age
      t.string :gender
      t.boolean :has_contact
      t.boolean :has_name
      t.string :screen_name
      t.string :description
      t.integer :followers_count
      t.integer :fans_count
      t.integer :weibo_count
      t.string :tags
      t.string :email
      t.string :qq
      t.string :msn
      t.string :school
      t.string :job
      t.string :birthday
      t.string :certification
      t.string :daren
      t.boolean :has_index
      t.timestamps
    end
  end
end
