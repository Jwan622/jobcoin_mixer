require 'sinatra'
require 'jobcoin_client'

get '/' do
  erb :add_coins
end
