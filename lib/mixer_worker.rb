class MixerWorker
  def self.perform_async
    transaction_history = JobcoinClient::Jobcoin.new.transaction_history
    identified_transactions = TransactionHandler.new(transaction_history, HouseDistributer::IDENTIFIER).process
    HouseDistributer.new(identified_transactions).make_transfers
  end
end
