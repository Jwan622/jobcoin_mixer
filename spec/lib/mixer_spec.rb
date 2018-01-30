require 'spec_helper'

RSpec.describe Mixer do
  let(:addresses) { ['address1, address2'] }
  let(:identifier) { 'testIdentifier' }

  describe 'encryption and decryption' do
    subject do
      encrypted = described_class.encrypt(addresses, identifier)
      described_class.decrypt(encrypted)
    end

    it 'encrypt returns an encrypted string which can then be decrypted back to the original + indentifier' do
      expect(subject).to eq(addresses.push(identifier))
    end
  end
end
