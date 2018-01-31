# libraries
require 'jobcoin_client'
require 'sinatra'
require 'pry' if development?
require 'bigdecimal'

# require lib
$:.unshift(File.expand_path('../jobcoin_mixer/lib'))
Dir.glob('lib/**/*.rb')
.tap { require 'distributor.rb'}
.each { |f| require_relative f }

# routes
get '/' do
  erb :add_coins
end

post '/mix_addresses' do
  new_addresses = params[:addresses].reject(&:empty?)
  mixed_address = Mixer.encrypt(new_addresses, HouseDistributor::IDENTIFIER)
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
  # going to get bigger + none of the following work needs to be seen by the customer
  MixerWorker.perform_async
end
