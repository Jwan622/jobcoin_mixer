class HouseDistributer < Distributer
  AGGREGATE_ACCOUNT = 'thisIsTheHouseAccount'
  IDENTIFIER = 'ThisTransactionIsOneOfOurs'

  def make_transfers
    to_aggregate_account(AGGREGATE_ACCOUNT)
    to_original_addresses(AGGREGATE_ACCOUNT)
  end
end
