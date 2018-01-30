require 'spec_helper'

RSpec.describe AccountingService do
  let(:service_instance) { described_class.new(origin_account) }

  let(:origin_account) { DataHelper::AGGREGATE_ACCOUNT }
  let(:contributions) do
    { 'address1' => 1.07, 'address2' => 1.07 }
  end

  let(:distributions) do
    {
      'address1' => 1.02,
      'address2' => 1.02,
      "52c7ec313568730cbadff4cb7b59dd5696d9917393f07ba92d74a6b3d1cc93a4057dd6ab03ddde6d938180ff" => 2.06
    }
  end

  let(:liabilities) do
    {
      'address1' => 0.05,
      'address2' => 0.05,
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
