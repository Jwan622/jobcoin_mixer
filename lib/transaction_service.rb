class TransactionService
  attr_reader :complete_transactions,
    :identifier

  def initialize(complete_transactions, identifier)
    @complete_transactions = complete_transactions
    @identifier = identifier
  end

  def process
    filter
    .group_by{ |transaction| transaction['toAddress'] }
    .map do |to, transactions|
      {
        'toAddress' => to,
        'amount' => transactions.inject(BigDecimal.new(0)) {|memo, trans| memo += BigDecimal.new(trans['amount']).to_f}
      }
    end
  end

  def filter
    # Supposed to match transactions from a single customer account to the mixed address
    complete_transactions.select do |transaction|
      Mixer.decrypt(transaction['toAddress']).pop == identifier if Mixer.decrypt(transaction['toAddress'])
    end
  end
end
