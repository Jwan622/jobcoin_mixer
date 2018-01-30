class TransactionHandler
  attr_reader :complete_transactions

  def initialize(complete_transactions)
    @complete_transactions = complete_transactions
  end

  def process(toAddress)
    filter(toAddress)
      .group_by{ |trans| trans['toAddress'] }
      .map do |to, to_transactions|
        {
          'toAddress' => to,
          'amount' => to_transactions.inject(0) {|memo, trans| memo += trans['amount'].to_f}
        }
    end
  end

  def filter(toAddress)
    # select only the transactions with a matching toAddress
    complete_transactions.select do |transaction|
      Mixer.decrypt(transaction['toAddress']).pop == toAddress
    end
  end
end
