class AddColLatLongPosts < ActiveRecord::Migration
  def change
  	add_column :posts, :latitude, :decimal
  	add_column :posts, :longitude, :decimal
  end
end
