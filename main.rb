require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require './models'
require 'byebug'
require 'bcrypt'
# require 'geocoder'

#for Heroku. Sets connection to db in app.sqlite3 through sqlite3
configure(:development){set :database, "sqlite3:app.sqlite3"}

enable :sessions

get '/' do
	erb :welcome
end

post '/signup' do
	my_password = BCrypt::Password.create(params[:password])
	@user = User.new(email: params[:email], password: my_password)
	@user.save
	session[:user_id] = @user.id
	redirect "/home"
end

post '/signin' do
	@user = User.find_by(email: params[:email])
	# .== is a method call for comparing passwords
	if @user && BCrypt::Password.new(@user.password).==(params[:password])
	  session[:user_id] = @user.id
	  redirect "/home"
	else
	  redirect "/"
	end
end

get '/logout' do
	# session[:user_id] = nil
	if current_user
	session.clear
	redirect '/'
  end
end

get '/home' do
	@posts = Post.all.order(:created_at).reverse
	@post_radius = Post.near([40.7985717, -73.5206119], 1).order(:created_at).reverse
	# @post_radius = Post.geocoded
	erb :home
end

post '/post' do
	Post.create(body: params[:body], latitude: params[:latitude], longitude: params[:longitude], user_id: current_user.id)
	redirect '/home'
end

get '/account' do
	@user = current_user
	erb :account
end

get '/user_posts' do
	@posts = Post.where(user_id: current_user.id).order(:created_at).reverse
	erb :user_posts
end

post '/delete_post' do
	@post = Post.find(params[:id])
	@post.destroy
	redirect '/user_posts'

end

# puts request
post '/update_account' do
  new_pass = BCrypt::Password.create(params[:password])
  @user = current_user.update(email: params[:email],password: new_pass)
  redirect '/account'
end

# delete request
post '/delete_account' do
	@user = current_user
	@user.destroy
	redirect '/'
end

def current_user
  if session[:user_id]
    @current_user = User.find(session[:user_id])
  end
end

def minutes_in_words(timestamp)
    minutes = (((Time.now - timestamp).abs)/60).round
    
    return nil if minutes < 0
    
    case minutes
      when 0..1            then 'less than 2 minutes'
      when 2..4            then 'less than 5 minutes'
      when 5..9            then 'less than 10 minutes'
      when 10..14		   then 'less than 15 minutes'
      when 15..29          then 'less than 30 minutes'
      when 30..44          then 'less than 45 minutes'
      when 45..59          then 'less than 1 hour'
      when 60..90          then 'more than 1 hour'
      when 89..119		   then 'less than 2 hours'
      when 120..179        then 'less than 3 hours'
      when 180..239        then 'less than 4 hours'
      when 240..719		   then 'less than 11 hours'
      when 720..1439       then 'less than 12 hours'
      when 1440..11519     then 'less than a day'
      # when 11520..43199    then '&gt; ' << pluralize((minutes/11520).floor, 'week')
      # when 43200..525599   then '&gt; ' << pluralize((minutes/43200).floor, 'month')  
      # else                      '&gt; ' << pluralize((minutes/525600).floor, 'year')
    end
  end
