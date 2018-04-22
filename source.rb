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


def get_search_count(term)

uri = URI("https://www.udemy.com/api-2.0/search-suggestions?q=#{term}")
search_amount = Net::HTTP.get(uri)
web_hash = JSON.parse(search_amount)
hash_value = web_hash ["results"][0]["searched_count"]
return hash_value

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
Coin.auto_upgrade!

get '/' do
	erb :stocks
	#return "this is the main page where the stocks will be shown here"
end

get '/about_us' do
	erb :about_us
	#return "info about us here"
end

get '/new_account' do
	erb :new_account
	#return "create a new account here"
end

get '/login' do
	erb :login
	#return "login here"
end

post '/my_account' do 
	erb :my_account
	#return "your account is here"
end



