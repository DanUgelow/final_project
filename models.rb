require 'geocoder'

class User < ActiveRecord::Base
  has_many :posts, dependent: :destroy
end

class Post < ActiveRecord::Base
  # adds geo codeer model activerec methods to post model as class methods
  extend Geocoder::Model::ActiveRecord
  # generates getter/setter fuctions which geolocotor uses implicitly
  attr_accessor :address
  belongs_to :user
  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode
end