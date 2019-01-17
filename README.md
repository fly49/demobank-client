# DemoBank-Client
An HTTP client for DemoBank.
## Requirements
You need next gems pre-installed:
```
gem 'faraday', "~> 0.15.3" 
gem 'faraday-cookie_jar', "~> 0.0.6"
gem 'nokogiri', "~> 1.8"
```
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
If it logged in successfully, you can get your accounts information:
```
client.accounts # => [ { type: :current, balance: 100, currency: 'USD' } ]
```
