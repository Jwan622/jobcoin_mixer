class DataHelper
  IDENTIFIER = 'ThisTransactionIsOneOfOurs'
  AGGREGATE_ACCOUNT = 'thisIsTheHouseAccount'

  def self.transaction_history
    addressAandBTransactions
    .concat(contributions)
    .concat(distributions)
    .concat(global_transactions)
  end

  def self.processed_transactions
    [
      {
        "toAddress"=>"eyJtZXNzYWdlIjoiYmFkNzkyZTY0N2JmNDZjOTc2NDc5NWY5NTIzMTYyYTQxZjhiYTllYTQ4Yjk3ODhhYzVjN2MwM2U5NDMyY2IwZDBlMmNkM2ZmOGU5NWFiNjJkZWMwNmFjMCIsImlkZW50aWZpZXIiOiJUaGlzVHJhbnNhY3Rpb25Jc09uZU9mT3VycyIsIml2IjoiMDllYzYyMDAyZTlmN2UyYTgwMmNiZWIxYjk4YTEzZjgifQ==",
        "amount"=>8.06
      }
    ]
  end

  def self.addressAandBTransactions
    [
      {"timestamp"=>"2018-01-18T02:57:34.959Z", "toAddress"=>addrAandB, "amount"=>"2"},
      {"timestamp"=>"2018-01-18T02:57:35.016Z", "fromAddress"=>"Alice", "toAddress"=>addrAandB, "amount"=>"4"}
    ]
  end

  def self.contributions
    [
      {"timestamp"=>"2018-01-23T23:35:25.464Z", "fromAddress"=>addrAandB, "toAddress"=>'thisIsTheHouseAccount', "amount"=>"1.06"},
      {"timestamp"=>"2018-01-23T23:35:25.464Z", "fromAddress"=>addrAandB, "toAddress"=>'thisIsTheHouseAccount', "amount"=>"1.08"}
    ]
  end

  def self.distributions
    distributions_to_mixed.concat(distributions_to_address)
  end

  def self.distributions_to_mixed
    # added house transactions sent to mixed addresses manually as an edge case.
    [
      {"timestamp"=>"2018-01-23T23:35:25.464Z", "fromAddress"=>'thisIsTheHouseAccount', "toAddress"=>addrAandB, "amount"=>"1.02"},
      {"timestamp"=>"2018-01-23T23:35:25.464Z", "fromAddress"=>'thisIsTheHouseAccount', "toAddress"=>addrAandB, "amount"=>"1.04"}
    ]
  end

  def self.distributions_to_address
    [
      {"timestamp"=>"2018-01-23T23:35:25.464Z", "fromAddress"=>'thisIsTheHouseAccount', "toAddress"=>'addressA', "amount"=>"1.02"},
      {"timestamp"=>"2018-01-23T23:35:25.464Z", "fromAddress"=>'thisIsTheHouseAccount', "toAddress"=>'addressB', "amount"=>"1.02"}
    ]
  end

  def self.address_transactions
    {
      'balance' => '5.0',
      'transactions' => distributions + contributions
    }
  end

  def self.global_transactions
    [
      {"timestamp"=>"2018-01-23T23:35:03.792Z", "fromAddress"=>"Alice", "toAddress"=>"Bob", "amount"=>"20"},
      {"timestamp"=>"2018-01-23T23:35:25.464Z", "fromAddress"=>"Alice", "toAddress"=>"Bob", "amount"=>"22"},
      {"timestamp"=>"2018-01-18T16:53:16.747Z", "toAddress"=>"52c7ec313568730cbaeaf8c67a68dc4495fb1cafda7d0571f4a5d3faf27753fc0e3039", "amount"=>"10"},
      {"timestamp"=>"2018-01-18T16:53:27.572Z", "fromAddress"=>"Alice", "toAddress"=>"52c7ec313568730cbaeaf8c67a68dc4495fb1cafda7d0571f4a5d3faf27753fc0e3039", "amount"=>"12"},
      {"timestamp"=>"2018-01-18T16:53:38.853Z", "fromAddress"=>"Bob", "toAddress"=>"52c7ec313568730cbaeaf8c67a68dc4495fb1cafda7d0571f4a5d3faf27753fc0e3039", "amount"=>"14"}
    ]
  end

  def self.identified_transactions
    transaction_history - global_transactions - contributions - distributions_to_address
  end

  private

  def self.addrAandB
    "eyJtZXNzYWdlIjoiYmFkNzkyZTY0N2JmNDZjOTc2NDc5NWY5NTIzMTYyYTQxZjhiYTllYTQ4Yjk3ODhhYzVjN2MwM2U5NDMyY2IwZDBlMmNkM2ZmOGU5NWFiNjJkZWMwNmFjMCIsImlkZW50aWZpZXIiOiJUaGlzVHJhbnNhY3Rpb25Jc09uZU9mT3VycyIsIml2IjoiMDllYzYyMDAyZTlmN2UyYTgwMmNiZWIxYjk4YTEzZjgifQ=="
  end

  def self.addr1
    "eyJtZXNzYWdlIjoiYzMwY2VjNjg1MWU5YzIxYzc4NjRhMTE2YjZiMjRjNzBhMDk0M2I3MzA0ODcxYTBjN2Q5MzAyYzM0MzYyZDAyMWNmMTE4M2ExYmJhNmNiNzRmOTM5OWFlZiIsImlkZW50aWZpZXIiOiJUaGlzVHJhbnNhY3Rpb25Jc09uZU9mT3VycyIsIml2IjoiZTZhYTcyZTVjN2EyNGY4NGQwZTY4ZWJlYTY4YzlkN2EifQ=="
  end
end
