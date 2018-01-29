class MixerWorker
  def self.perform_async
    transaction_history = JobcoinClient::Jobcoin.new.transaction_history
    filtered_history = TransactionHandler.new(transaction_history).process
    Distributer.new(filtered_history).make_transfers
  end
end
