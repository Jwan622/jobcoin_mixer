# libraries
require 'jobcoin_client'
require 'sinatra'
require 'pry' if development?

# lib
require './lib/distributer.rb'
require './lib/house_distributer.rb'
require './lib/mixer.rb'
require './lib/mixer_worker.rb'
require './lib/transaction_handler.rb'

get '/' do
  erb :add_coins
end

post '/mix_addresses' do
  new_addresses = params[:addresses].reject(&:empty?)
  mixed_address = Mixer.encrypt(new_addresses)
  { mixed_address: mixed_address }.to_json
end

post '/deposit' do
  amount = params[:amount]
  addressTo = params[:address_to]
  addressFrom = params[:address_from]

  res = JobcoinClient::Jobcoin.new.add_transaction(addressFrom, addressTo, amount)
  res.to_json
end

after '/deposit' do
  # should be done asynchronously since that transaction history ledger is only
  # going to get bigger.
  MixerWorker.perform_async
end
