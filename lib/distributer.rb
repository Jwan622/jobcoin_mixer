class Distributer
  attr_reader :transactions

  def initialize(transactions)
    @transactions = transactions
  end

  private

  def to_aggregate_account(to)
    transactions.each do |trans|
      from_address = trans['toAddress']
      remaining_balance = JobcoinClient::Jobcoin.new.address_transactions(from_address)['balance'].to_f

      # this will throw an error if the from account has fewer jobcoins than amount
      # So, we only transfer the remaining amount in each mixed address
      JobcoinClient::Jobcoin.new.add_transaction(
        from_address,
        to,
        remaining_balance
      ) if remaining_balance > 0.0
    end
  end

  def to_original_addresses(from)
    liabilities = AccountingService.new(from).liabilities

    # make distributions from AGGREGATE_ACCOUNT to original accounts
    liabilities.each do |addr, amount|
      JobcoinClient::Jobcoin.new.add_transaction(from, addr, amount)
    end
  end
end
