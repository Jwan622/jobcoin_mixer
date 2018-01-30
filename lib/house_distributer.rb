class HouseDistributer
  attr_reader :transactions

  HOUSE_ACCOUNT = 'thisIsTheHouseAccount'
  HOUSE_IDENTIFIER = 'ThisTransactionIsOneOfOurs'

  def initialize(transactions)
    @transactions = transactions
  end

  def make_transfers
    to_house_account
    to_original_addresses
  end

  private

  def to_house_account
    transactions.each do |trans|
      mixed_address = trans['toAddress']
      remaining_mixed_amount = JobcoinClient::Jobcoin.new.address_transactions(mixed_address)['balance']

      # this will throw an error if the from account has fewer jobcoins than amount
      # So, we only transfer the remaining amount in each mixed address
      JobcoinClient::Jobcoin.new.add_transaction(mixed_address, HOUSE_ACCOUNT, remaining_mixed_amount)
    end
  end

  def to_original_addresses
    house_credits = JobcoinClient::Jobcoin.new.address_transactions('thisIsTheHouseAccount')['transactions'].select do |trans|
      trans['toAddress'] == HOUSE_ACCOUNT
    end

    to_distribute = house_credits.reduce(Hash.new(0)) do |balances, credit|
      original_addresses = Mixer.decrypt(credit['fromAddress']).tap(&:pop)
      amount_to_distribute = credit['amount'].to_f/(original_addresses.count)

      original_addresses.each do |addr|
        balances[addr] += amount_to_distribute
      end

      balances
    end

    house_debits = JobcoinClient::Jobcoin.new.address_transactions('thisIsTheHouseAccount')['transactions'].select do |trans|
      trans['fromAddress'] == HOUSE_ACCOUNT
    end

    distributed = house_debits.reduce(Hash.new(0)) do |balances, debit|
      original_address = debit['toAddress']
      balances[original_address] += debit['amount'].to_f
      balances
    end

    # subtract the debits from the credits
    unsettled_distributions = to_distribute.merge(distributed) do |key, credit, debit|
      credit - debit
    end.select { |addr, amount| amount != 0.0 }
    # distributions from House account to original accounts
    unsettled_distributions.each do |addr, amount|
      JobcoinClient::Jobcoin.new.add_transaction(HOUSE_ACCOUNT, addr, amount)
    end
  end
end
