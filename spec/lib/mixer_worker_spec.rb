require 'spec_helper'

RSpec.describe MixerWorker do
  describe "#perform_async" do
    subject { described_class.perform_async }

    let(:transactions) { DataHelper.transaction_history }
    let(:processed_transactions) { DataHelper.processed_transactions }
    let(:distributor_instance) { instance_double(HouseDistributor) }

    it 'passes the proper transactions to the distributor' do
      expect_any_instance_of(JobcoinClient::Jobcoin).to receive(:transaction_history) { transactions }
      expect_any_instance_of(TransactionService).to receive(:process) { processed_transactions }
      expect(HouseDistributor).to receive(:new).with(processed_transactions) { distributor_instance }
      expect(distributor_instance).to receive(:make_transfers)

      subject
    end
  end
end
