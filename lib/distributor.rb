class Distributor
  attr_reader :transactions, :client

  def initialize(transactions)
    @transactions = transactions
    @client = JobcoinClient::Jobcoin.new
  end

  private

  def to_aggregate_account
    transactions.each do |trans|
      from_address = trans['toAddress']
      remaining_balance = client.address_transactions(from_address)['balance'].to_f

      # this will throw an error if we try to transfer an amount greater than
      # what's in the from_address or if we try to transfer 0.0. So, we will
      # only transfer an amount > 0
      # Also, if someone tries to transfer from house to an encrypted address, the transfer should
      # be returned back to the House Account here.
      client.add_transaction(
        from_address,
        self.class::AGGREGATE_ACCOUNT,
        remaining_balance
      ) if remaining_balance > 0.0
    end
  end

  def to_original_addresses
    liabilities = AccountingService.new(self.class::AGGREGATE_ACCOUNT).liabilities

    # make distributions from AGGREGATE_ACCOUNT to original accounts
    liabilities.each do |addr, amount|
      client.add_transaction(self.class::AGGREGATE_ACCOUNT, addr, amount)
    end
  end
end
