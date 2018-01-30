require 'spec_helper'

RSpec.describe MixerWorker do
  describe "#perform_async" do
    subject { described_class.perform_async }

    let(:transactions) { DataHelper.transaction_history }
    let(:processed_transactions) { DataHelper.processed_transactions }
    let(:distributer_instance) { instance_double(HouseDistributer) }

    it 'passes the proper transactions to the distributer' do
      expect_any_instance_of(JobcoinClient::Jobcoin).to receive(:transaction_history) { transactions }
      expect_any_instance_of(TransactionService).to receive(:process) { processed_transactions }
      expect(HouseDistributer).to receive(:new).with(processed_transactions) { distributer_instance }
      expect(distributer_instance).to receive(:make_transfers)

      subject
    end
  end
end
