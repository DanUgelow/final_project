class IndexLatLon < ActiveRecord::Migration
  def change
  	add_index :posts, [:latitude, :longitude]
  end
end
