# DemoBank-Client
An HTTP client for DemoBank.
## Installation
1. `git clone git://github.com/fly49/demobank-client.git`
2. `cd demobank-client`
3. `gem build demobank-client.gemspec`
4. `gem install demobank-client-0.1.0.gem`
## Usage
Initialize DemoBankClient object and try to log in:
```
require 'demobank-client`

client = DemoBankClient.new
client.login(username: 'customer', password: 'qwerty') # => true/false
```
If it logged in successfully, you could access to your accounts information:
```
client.accounts # => [ { type: :current, balance: 100, currency: 'USD' } ]
```
