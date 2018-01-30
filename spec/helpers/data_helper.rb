class DataHelper
  IDENTIFIER = 'ThisTransactionIsOneOfOurs'
  AGGREGATE_ACCOUNT = 'thisIsTheHouseAccount'

  def self.transaction_history
    address1
    .concat(address1_and_address2)
    .concat(address3)
    .concat(contributions)
    .concat(distributions)
    .concat(global_transactions)
  end

  def self.processed_transactions
    [
      {
        "toAddress"=>"52c7ec313568730cbaeaf8c67a68dc4495fb1cafda7d0571f4a5d3faf27753fc0e3039",
        "amount"=>36.0
      },
      {
        "toAddress"=>"52c7ec313568730cbadff4cb7b59dd5696d9917393f07ba92d74a6b3d1cc93a4057dd6ab03ddde6d938180ff",
        "amount"=>8.059999999999999
      },
      {
        "toAddress"=>"52c7ec313568730ebaeaf8c67a68dc44295b5161184de55c420e8db2c4e07dbf5bad21",
        "amount"=>1.0
      }
    ]
  end

  def self.address1
    [
      {"timestamp"=>"2018-01-18T16:53:16.747Z", "toAddress"=>"52c7ec313568730cbaeaf8c67a68dc4495fb1cafda7d0571f4a5d3faf27753fc0e3039", "amount"=>"10"},
      {"timestamp"=>"2018-01-18T16:53:27.572Z", "fromAddress"=>"Alice", "toAddress"=>"52c7ec313568730cbaeaf8c67a68dc4495fb1cafda7d0571f4a5d3faf27753fc0e3039", "amount"=>"12"},
      {"timestamp"=>"2018-01-18T16:53:38.853Z", "fromAddress"=>"Bob", "toAddress"=>"52c7ec313568730cbaeaf8c67a68dc4495fb1cafda7d0571f4a5d3faf27753fc0e3039", "amount"=>"14"}
    ]
  end

  def self.address1_and_address2
    [
      {"timestamp"=>"2018-01-18T02:57:34.959Z", "toAddress"=>"52c7ec313568730cbadff4cb7b59dd5696d9917393f07ba92d74a6b3d1cc93a4057dd6ab03ddde6d938180ff", "amount"=>"2"},
      {"timestamp"=>"2018-01-18T02:57:35.016Z", "fromAddress"=>"Alice", "toAddress"=>"52c7ec313568730cbadff4cb7b59dd5696d9917393f07ba92d74a6b3d1cc93a4057dd6ab03ddde6d938180ff", "amount"=>"4"}
    ]
  end

  def self.address3
    [
      {"timestamp"=>"2018-01-23T23:35:25.464Z", "fromAddress"=>"Alice", "toAddress"=>"52c7ec313568730ebaeaf8c67a68dc44295b5161184de55c420e8db2c4e07dbf5bad21", "amount"=>"1"}
    ]
  end

  def self.contributions
    [
      {"timestamp"=>"2018-01-23T23:35:25.464Z", "fromAddress"=>"52c7ec313568730cbadff4cb7b59dd5696d9917393f07ba92d74a6b3d1cc93a4057dd6ab03ddde6d938180ff", "toAddress"=>'thisIsTheHouseAccount', "amount"=>"1.06"},
      {"timestamp"=>"2018-01-23T23:35:25.464Z", "fromAddress"=>"52c7ec313568730cbadff4cb7b59dd5696d9917393f07ba92d74a6b3d1cc93a4057dd6ab03ddde6d938180ff", "toAddress"=>'thisIsTheHouseAccount', "amount"=>"1.08"}
    ]
  end

  def self.distributions
    distributions_to_mixed.concat(distributions_to_address)
  end

  def self.distributions_to_mixed
    # added house transactions sent to mixed addresses manually as an edge case.
    [
      {"timestamp"=>"2018-01-23T23:35:25.464Z", "fromAddress"=>'thisIsTheHouseAccount', "toAddress"=>"52c7ec313568730cbadff4cb7b59dd5696d9917393f07ba92d74a6b3d1cc93a4057dd6ab03ddde6d938180ff", "amount"=>"1.02"},
      {"timestamp"=>"2018-01-23T23:35:25.464Z", "fromAddress"=>'thisIsTheHouseAccount', "toAddress"=>"52c7ec313568730cbadff4cb7b59dd5696d9917393f07ba92d74a6b3d1cc93a4057dd6ab03ddde6d938180ff", "amount"=>"1.04"}
    ]
  end

  def self.distributions_to_address
    [
      {"timestamp"=>"2018-01-23T23:35:25.464Z", "fromAddress"=>'thisIsTheHouseAccount', "toAddress"=>"address1", "amount"=>"1.02"},
      {"timestamp"=>"2018-01-23T23:35:25.464Z", "fromAddress"=>'thisIsTheHouseAccount', "toAddress"=>"address2", "amount"=>"1.02"}
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
      {"timestamp"=>"2018-01-23T23:35:25.464Z", "fromAddress"=>"Alice", "toAddress"=>"Bob", "amount"=>"22"}
    ]
  end

  def self.identified_transactions
    transaction_history - global_transactions - contributions - distributions_to_address
  end
end
