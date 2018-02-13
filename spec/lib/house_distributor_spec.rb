require 'spec_helper'

RSpec.describe HouseDistributor do
  let(:distributor_instance) { described_class.new(processed_transactions) }
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
      .with("eyJtZXNzYWdlIjoiYmFkNzkyZTY0N2JmNDZjOTc2NDc5NWY5NTIzMTYyYTQxZjhiYTllYTQ4Yjk3ODhhYzVjN2MwM2U5NDMyY2IwZDBlMmNkM2ZmOGU5NWFiNjJkZWMwNmFjMCIsImlkZW50aWZpZXIiOiJUaGlzVHJhbnNhY3Rpb25Jc09uZU9mT3VycyIsIml2IjoiMDllYzYyMDAyZTlmN2UyYTgwMmNiZWIxYjk4YTEzZjgifQ==")
      .and_return({ 'balance' => 1.0 })
    allow_any_instance_of(AccountingService).to receive(:liabilities) { { 'address3' => 1.0 } }
  end

  describe '#make_transfers' do
    subject { distributor_instance.make_transfers }

    it 'makes the transfer to the house account only if there is a remaining balance' do
      expect(jobcoin_client).not_to receive(:add_transaction)
      .with(
        "52c7ec313568730cbaeaf8c67a68dc4495fb1cafda7d0571f4a5d3faf27753fc0e3039",
        'thisIsTheHouseAccount3',
        0.0
      )
      expect(jobcoin_client).not_to receive(:add_transaction)
      .with(
        "52c7ec313568730cbadff4cb7b59dd5696d9917393f07ba92d74a6b3d1cc93a4057dd6ab03ddde6d938180ff",
        'thisIsTheHouseAccount3',
        0.0
      )
      expect(jobcoin_client).to receive(:add_transaction)
      .with(
        "eyJtZXNzYWdlIjoiYmFkNzkyZTY0N2JmNDZjOTc2NDc5NWY5NTIzMTYyYTQxZjhiYTllYTQ4Yjk3ODhhYzVjN2MwM2U5NDMyY2IwZDBlMmNkM2ZmOGU5NWFiNjJkZWMwNmFjMCIsImlkZW50aWZpZXIiOiJUaGlzVHJhbnNhY3Rpb25Jc09uZU9mT3VycyIsIml2IjoiMDllYzYyMDAyZTlmN2UyYTgwMmNiZWIxYjk4YTEzZjgifQ==",
        'thisIsTheHouseAccount3',
        1.0
      )
      expect(jobcoin_client).to receive(:add_transaction)
      .with(
        'thisIsTheHouseAccount3',
        'address3',
        1.0
      )

      subject
    end
  end
end
