require 'sinatra'
require 'data_mapper' # metagem, requires common plugins too.
require 'net/http'
require 'json'
require 'openssl'


if ENV['DATABASE_URL']
  DataMapper::setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
else
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/CrypticalC.db")
end


OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class User
    include DataMapper::Resource
    property :id, Serial
    property :email, String
    property :password, String
    property :created_at, DateTime

    def login(password)
        return self.password == password
    end
end



class Coin
    include DataMapper::Resource
    property :id, Serial
    property :title, String
    property :body, Text
    property :created_at, DateTime
end


# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models
DataMapper.finalize

# automatically create the post table
User.auto_upgrade!

Coin.auto_upgrade!


enable :sessions

#This method will return the user object of the currently signed in user
#Returns nil if not signed in
def current_user
	if(session[:user_id])
		u = User.first(id: session[:user_id])
		return u
	else
		return nil
	end
end

#if the user is not signed in, will redirect to login page
def authenticate!
	if !current_user
		redirect "/login"
	end
end


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


