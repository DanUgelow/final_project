require 'geocoder'

class User < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  
  has_secure_password
  validates(:email, 
    presence: true, 
    uniqueness: true)

  validates(:password, 
    presence: true,
    on: :create, 
    confirmation: true)
    # length:{minimum: 5}

  # validates(:password_confirmation, 
  #   presence: true, 
  #   confirmation: true)


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