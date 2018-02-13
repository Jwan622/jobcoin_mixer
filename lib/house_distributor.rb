class HouseDistributor < Distributor
  AGGREGATE_ACCOUNT = 'thisIsTheHouseAccount3'
  IDENTIFIER = 'ThisTransactionIsOneOfOurs'

  def make_transfers
    to_aggregate_account
    to_original_addresses
  end
end
