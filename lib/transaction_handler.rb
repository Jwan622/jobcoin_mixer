class TransactionHandler
  attr_reader :complete_transactions

  def initialize(complete_transactions)
    @complete_transactions = complete_transactions
  end

  def process
    # find the toAddress that are mixer addresses. run array through decryption and you're left with those.
    mixer_transactions = complete_transactions.select do |transaction|
      Mixer.decrypt(transaction['toAddress']).pop ==  Mixer::IDENTIFIER
    end

    mixer_transactions
      .group_by{ |trans| trans['toAddress'] }
      .map do |to, to_transactions|
        {
          'toAddress' => to,
          'amount' => to_transactions.inject(0) {|memo, trans| memo += trans['amount'].to_f},
          'fromAddress' => to_transactions.map {|trans| trans['fromAddress']}.compact.uniq
        }
    end
  end
end
