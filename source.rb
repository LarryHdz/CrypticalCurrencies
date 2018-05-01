require 'sinatra'
require 'data_mapper' # metagem, requires common plugins too.
require 'net/http'
require 'json'
require 'openssl'
require_relative "authentication.rb"
require_relative "user.rb"


get '/' do
	erb :betacoin
	#return "this is the main page where the stocks will be shown here"
end

get '/about_us' do
	erb :about_us
	#return "info about us here"
end


get '/new_account' do
	erb :"new_account"
	#return "create a new account here"
end

post "/register" do
	email = params[:email]
	password = params[:password]

	u = User.new
	u.email = email.downcase
	u.password =  password
	u.save

	session[:user_id] = u.id

	erb :"authentication/successful_signup"

end



get '/login' do
	erb :"login"
	#return "login here"
end

post "/process_login" do
	email = params[:email]
	password = params[:password]

	user = User.first(email: email.downcase)

	if(user && user.login(password))
		session[:user_id] = user.id
		redirect "/"
	else
		erb :"authentication/invalid_login"
	end
end


get '/my_account' do
	authenticate! 
	erb :my_account
	#return "your account is here"
end


get "/dashboard" do
	authenticate!
 	erb :coins
end



get "/logout" do
	session[:user_id] = nil
	redirect "/"
end

get"/testing" do
	erb :betacoin
	end


