require 'sinatra'
require 'jobcoin_client'
require 'pry' if development?

get '/' do
  erb :add_coins
end

post '/mix_addresses' do
  binding.pry
  puts params['addresses']
end
