# DemoBank-Client
An HTTP client for DemoBank.
## Installation
Add following line to your Gemfile
```
gem 'demobank-client', :git => 'https://github.com/fly49/demobank-client.git'
```
and
```
bundle install
```
## Usage
Initialize DemoBankClient object and try to log in:
```
require 'demobank-client`

client = DemoBankClient.new
client.login(username: 'customer', password: 'qwerty') # => true/false
```
If it logged in successfully, you can get your accounts information:
```
client.accounts # => [ { type: :current, balance: 100, currency: 'USD' } ]
```
