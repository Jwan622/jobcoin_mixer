require 'spec_helper'

RSpec.describe AccountingService do
  let(:service_instance) { described_class.new(origin_account) }

  let(:origin_account) { DataHelper::AGGREGATE_ACCOUNT }
  let(:contributions) do
    { 'addressA' => BigDecimal.new('1.07'), 'addressB' => BigDecimal.new('1.07') }
  end

  let(:distributions) do
    {
      'addressA' => 0.102e1,
      'addressB' => 0.102e1,
      "eyJtZXNzYWdlIjoiYmFkNzkyZTY0N2JmNDZjOTc2NDc5NWY5NTIzMTYyYTQxZjhiYTllYTQ4Yjk3ODhhYzVjN2MwM2U5NDMyY2IwZDBlMmNkM2ZmOGU5NWFiNjJkZWMwNmFjMCIsImlkZW50aWZpZXIiOiJUaGlzVHJhbnNhY3Rpb25Jc09uZU9mT3VycyIsIml2IjoiMDllYzYyMDAyZTlmN2UyYTgwMmNiZWIxYjk4YTEzZjgifQ==" => 0.206e1
    }
  end

  let(:liabilities) do
    {
      'addressA' => 0.05,
      'addressB' => 0.05,
    }
  end

  before do
    allow_any_instance_of(JobcoinClient::Jobcoin)
    .to receive(:address_transactions) { DataHelper.address_transactions }
  end

  describe '#contributions' do
    subject { service_instance.contributions }

    it 'correctly returns the contributions made to the origin acccount from various addresses' do
      expect(subject).to eq(contributions)
    end

    it 'ignores distributions' do
      expect(subject).not_to include(distributions)
    end
  end

  describe '#distributions' do
    subject { service_instance.distributions }

    it 'correctly returns the distributions made from the origin acccount to various addresses' do
      expect(subject).to eq(distributions)
    end
  end

  describe '#liabilities' do
    subject { service_instance.liabilities }

    it 'correctly returns the liabilities or the distributions not yet paid' do
      expect(subject).to eq(liabilities)
    end
  end
end
