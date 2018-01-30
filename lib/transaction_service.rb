class TransactionService
  attr_reader :complete_transactions,
    :identifier

  def initialize(complete_transactions, identifier)
    @complete_transactions = complete_transactions
    @identifier = identifier
  end

  def process
    filter(identifier)
    .group_by{ |transaction| transaction['toAddress'] }
    .map do |to, transactions|
      {
        'toAddress' => to,
        'amount' => transactions.inject(0) {|memo, trans| memo += trans['amount'].to_f}
      }
    end
  end

  def filter(toAddress)
    # select only the transactions with a matching identifier (found in a
    # decrypted toAddress)
    complete_transactions.select do |transaction|
      Mixer.decrypt(transaction['toAddress']).pop == identifier
    end
  end
end