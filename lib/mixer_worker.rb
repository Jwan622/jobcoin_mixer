class MixerWorker
  def self.perform_async
    transaction_history = JobcoinClient::Jobcoin.new.transaction_history
    identified_transactions = TransactionService.new(transaction_history, HouseDistributor::IDENTIFIER).process
    HouseDistributor.new(identified_transactions).make_transfers
  end
end
