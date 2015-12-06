class CreatePosts < ActiveRecord::Migration
  def change
  	create_table :posts do |t|
  	  t.string :subject
  	  t.string :body
  	  t.integer :user_id
  	end
  end
end
