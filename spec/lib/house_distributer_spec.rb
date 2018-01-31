require 'spec_helper'

RSpec.describe HouseDistributer do
  let(:distributer_instance) { described_class.new(processed_transactions) }
  let(:processed_transactions) { DataHelper.processed_transactions }
  let(:jobcoin_client) { instance_double(JobcoinClient::Jobcoin) }

  before do
    allow(JobcoinClient::Jobcoin).to receive(:new) { jobcoin_client }
    allow(jobcoin_client).to receive(:address_transactions)
      .with("52c7ec313568730cbaeaf8c67a68dc4495fb1cafda7d0571f4a5d3faf27753fc0e3039")
      .and_return({ 'balance' => 0.0 })
    allow(jobcoin_client).to receive(:address_transactions)
      .with("52c7ec313568730cbadff4cb7b59dd5696d9917393f07ba92d74a6b3d1cc93a4057dd6ab03ddde6d938180ff")
      .and_return({ 'balance' => 0.0 })
    allow(jobcoin_client).to receive(:address_transactions)
      .with("52c7ec313568730ebaeaf8c67a68dc44295b5161184de55c420e8db2c4e07dbf5bad21")
      .and_return({ 'balance' => 1.0 })
    allow_any_instance_of(AccountingService).to receive(:liabilities) { { 'address3' => 1.0 } }
  end

  describe '#make_transfers' do
    subject { distributer_instance.make_transfers }

    it 'makes the transfer to the house account only if there is a remaining balance' do
      expect(jobcoin_client).not_to receive(:add_transaction)
      .with(
        "52c7ec313568730cbaeaf8c67a68dc4495fb1cafda7d0571f4a5d3faf27753fc0e3039",
        'thisIsTheHouseAccount',
        0.0
      )
      expect(jobcoin_client).not_to receive(:add_transaction)
      .with(
        "52c7ec313568730cbadff4cb7b59dd5696d9917393f07ba92d74a6b3d1cc93a4057dd6ab03ddde6d938180ff",
        'thisIsTheHouseAccount',
        0.0
      )
      expect(jobcoin_client).to receive(:add_transaction)
      .with(
        "52c7ec313568730ebaeaf8c67a68dc44295b5161184de55c420e8db2c4e07dbf5bad21",
        'thisIsTheHouseAccount',
        1.0
      )
      expect(jobcoin_client).to receive(:add_transaction)
      .with(
        'thisIsTheHouseAccount',
        'address3',
        1.0
      )

      subject
    end
  end
end
