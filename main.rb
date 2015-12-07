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
	# retrieve db password and unencrypt to compare. New is a bcrypt method
	db_password = BCrypt::Password.new(@user.password)
	if @user.password == db_password
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
	@posts = Post.all
	erb :home
end

post '/post' do
	Post.create(body: params[:body], user_id: current_user.id)
	redirect '/home'
end

get '/account' do
	@user = current_user
	erb :account
end

get '/user_posts' do
	@posts = Post.where(user_id: current_user.id)
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
