class Distributer
  HOUSE_ACCOUNT = 'thisIsTheHouseAccount'
  attr_reader :transactions

  def initialize(transactions)
    @transactions = transactions
  end

  def make_transfers
    to_house_account
    to_original_addresses
  end

  def to_house_account
    
  end
end
