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

  if res['status'] == 'OK'
    transfers = MixerWorker.perform_async
    res['transfers'] = transfers.map { |addr, amt| { to: addr, amount: amt } }
    res.to_json
  else
    res.to_json
  end
end
