class MixerWorker
  def self.perform_async
    transaction_history = JobcoinClient::Jobcoin.new.transaction_history
    grouped_mixer_transactions = TransactionHandler.new(transaction_history).process(HouseDistributer::IDENTIFIER)
    Distributer.new(HouseDistributer.new(grouped_mixer_transactions)).make_transfers
  end
end
