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


def get_search_count(term)

uri = URI("https://www.udemy.com/api-2.0/search-suggestions?q=#{term}")
search_amount = Net::HTTP.get(uri)
web_hash = JSON.parse(search_amount)
hash_value = web_hash ["results"][0]["searched_count"]
return hash_value

end

# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models
DataMapper.finalize

# automatically create the post table
User.auto_upgrade!

Coin.auto_upgrade!