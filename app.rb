require 'sinatra'
require 'jobcoin_client'
require 'pry' if development?
require './lib/encoder.rb'
# require 'json'

get '/' do
  erb :add_coins
end

post '/mix_addresses' do
  new_addresses = params['addresses'].reject(&:empty?)
  # unsure what characters are valid inputs for addresses, but this pipe seems
  # unlikely?
  mixed_address = Encoder.encrypt(new_addresses)
  content_type :json
  { mixed_address: mixed_address }.to_json
end
