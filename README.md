## Jobcoin Mixer

####Table of Contents


#### TransactionHandler

```ruby
[{"toAddress"=>"0297bc772c4f6854b5eae2ce674fcf46f23d3574f1f13989919faaaf11c873", "amount"=>50.256899999999995, "fromAddress"=>["1444", "alice", "Alice"]},
 {"toAddress"=>"52cfe12035675455afcdc4dd6852dd4499463ce04f1c37bb17c645b26b4b4116", "amount"=>2.11, "fromAddress"=>["1444"]},
 {"toAddress"=>"52c7ec313568730cbadff4cb7b59dd5696d9917393f07ba92d74a6b3d1cc93a4057dd6ab03ddde6d938180ff", "amount"=>10.0, "fromAddress"=>["1444"]}]
```

In the above code, the `TransactionHandler` polls the Jobcoin history for transactions that sent to addresses created by the Mixer. These addresses can then be used

####Distributer logic

Issues:
1. How to make the methods idempotent. If one fails, I should be able to safely rerun the methods without running the risk of duplicate transfers.


- The house account has all the aggregated jobcoins. The issue here is determining which accounts to transfer jobcoins to while also avoiding duplicate
transfers.


#### Image Choice
- Xhibit meme was the clearest choice I had all project.
