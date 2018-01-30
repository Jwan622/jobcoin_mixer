class HouseDistributer < Distributer
  AGGREGATE_ACCOUNT = 'thisIsTheHouseAccount'
  IDENTIFIER = 'ThisTransactionIsOneOfOurs'

  def make_transfers
    to_aggregate_account
    to_original_addresses
  end
end
