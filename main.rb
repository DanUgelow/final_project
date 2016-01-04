require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require './models'
require 'byebug'
require 'bcrypt'



#for Heroku. Sets connection to db in app.sqlite3 through sqlite3
configure(:development){set :database, "sqlite3:app.sqlite3"}

enable :sessions

get '/' do
	@user = User.new
	erb :welcome
end

get '/about' do
	erb :about
end

post '/signup' do
	# my_password = BCrypt::Password.create(params[:password])
	# @user = User.new(email: params[:email], password: my_password, password_confirmation: params[:password_confirmation])
	@user = User.new(email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation])
	if @user.save
	  session[:user_id] = @user.id
	  redirect "/home"
	else
	  redirect '/'
	end
end

post '/signin' do
	@user = User.find_by(email: params[:email])
	# .== is a method call for comparing passwords
	# if @user && BCrypt::Password.new(@user.password).==(params[:password])
	if @user && @user.authenticate(params[:password])
	  session[:user_id] = @user.id
	  redirect "/home"
	else
	  flash[:alert] = "Incorrect email or password"
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

get '/home/location' do
	@posts = Post.near([params[:lat], params[:lon]], 1)
	erb :location, :layout => false
end


get '/home' do
	@latitude = params[:lat]
    @longitude = params[:lon]
    # fix order of posts
	# @posts = Post.all
	# .order(:created_at).reverse
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
      when 0..59           then "#{minutes} minutes ago"
      when 60..90          then 'More than 1 hour ago'
      when 89..119		   then 'Less than 2 hours ago'
      when 120..179        then 'Less than 3 hours ago'
      when 180..239        then 'Less than 4 hours ago'
      when 240..719		   then 'Less than 11 hours ago'
      when 720..1439       then 'Less than 12 hours ago'
      when 1440..11519     then 'Less than a day ago'
      # when 11520..43199    then '&gt; ' << pluralize((minutes/11520).floor, 'week')
      # when 43200..525599   then '&gt; ' << pluralize((minutes/43200).floor, 'month')  
      # else                      '&gt; ' << pluralize((minutes/525600).floor, 'year')
    end
  end