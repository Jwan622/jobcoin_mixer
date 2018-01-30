class AccountingService
  attr_reader :origin_account

  def initialize(origin_account)
    @origin_account = origin_account
  end

  def liabilities
    contributions.merge(distributions) do |key, con, dis|
      con - dis
    end.select { |addr, amount| amount != 0.0 }
  end

  def contributions
    contributions = JobcoinClient::Jobcoin.new.address_transactions(origin_account)['transactions'].select do |trans|
      trans['toAddress'] == origin_account
    end

    contributions.reduce(Hash.new(0)) do |balances, cont|
      distribution_addresses = Mixer.decrypt(cont['fromAddress']).tap(&:pop)
      amount_to_distribute = cont['amount'].to_f/(distribution_addresses.count)

      distribution_addresses.each do |addr|
        balances[addr] += amount_to_distribute
      end

      balances
    end
  end

  def distributions
    distributions = JobcoinClient::Jobcoin.new.address_transactions(origin_account)['transactions'].select do |trans|
      trans['fromAddress'] == origin_account
    end

    distributions.reduce(Hash.new(0)) do |balances, dist|
      distribution_address = dist['toAddress']
      balances[distribution_address] += dist['amount'].to_f
      balances
    end
  end
end
