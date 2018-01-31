class AccountingService
  attr_reader :origin_account,
    :distributions,
    :contributions

  def initialize(origin_account)
    @origin_account = origin_account
  end

  def liabilities
    @contributions ||= contributions
    @distributions ||= distributions

    @contributions.merge(@distributions) do |key, con, dis|
      (BigDecimal.new(con.to_s) - BigDecimal.new(dis.to_s)).to_f
    end.select { |addr, amount| amount != 0.0 && @contributions.keys.include?(addr) }
  end

  def contributions
    contributions = JobcoinClient::Jobcoin.new.address_transactions(origin_account)['transactions'].select do |trans|
      # we don't want to include creation transactions. We only want transfers with a fromAddress
      trans['toAddress'] == origin_account && !trans['fromAddress'].nil?
    end

    contributions.reduce(Hash.new(0)) do |balances, cont|
      distribution_addresses = Mixer.decrypt(cont['fromAddress']).tap(&:pop)
      amount_to_distribute = (BigDecimal.new(cont['amount'])/BigDecimal.new(distribution_addresses.count.to_s)).to_f

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
      balances[distribution_address] += BigDecimal.new(dist['amount']).to_f
      balances
    end
  end
end
