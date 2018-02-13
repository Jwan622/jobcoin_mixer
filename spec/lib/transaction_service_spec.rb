require 'spec_helper'

RSpec.describe TransactionService do
  let(:service_instance) { described_class.new(transactions, identifier) }

  let(:identifier) { DataHelper::IDENTIFIER }
  let(:transactions) { DataHelper.transaction_history }

  describe "#process" do
    subject { service_instance.process }

    let(:processed_transactions) { DataHelper.processed_transactions }

    it 'returns aggregate amounts for every toAddress' do
      expect(subject).to match_array(processed_transactions)
    end
  end

  describe '#filter' do
    subject { service_instance.filter }

    let(:global_transactions) { DataHelper.global_transactions }
    let(:identified_transactions) { DataHelper.identified_transactions }

    it 'rejects global transactions' do
      global_transactions.each do |rejected|
        expect(subject).not_to include(rejected)
      end
    end

    it 'only includes identifier transactions' do
      expect(subject).to match_array(identified_transactions)
    end
  end
end
