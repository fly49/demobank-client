require 'webmock/rspec'
require 'spec_helper'
require 'demobank-client'

describe DemoBankClient do
  let!(:client) { DemoBankClient.new }
  let!(:bank_url) { "https://verify-demo-bank.herokuapp.com/" }
  let!(:credentials) { {username: 'test', password: 'test'} }
  let!(:auth_token) { "xqu5pYBHO//Yz3VHE+9bTLKbUI0Jv9hcKXHg1xRaXM+Qn3X0JsafGiE1yeRrSr0NZh3gBCC+j5PuxxNp4XoxYg==" }
  let!(:auth_token_form) { %Q(<input type="hidden" name="authenticity_token" value=#{auth_token} />) }
  
  let!(:login_regex) { Regexp.new(bank_url + "login") }
  let!(:accounts_regex) { Regexp.new(bank_url + "accounts") }
  
  let!(:login_post) do
    WebMock.stub_request(:post, login_regex)
  end
  let!(:login_get) do
    WebMock.stub_request(:get, login_regex)
  end
  let!(:accounts_get) do
    WebMock.stub_request(:get, accounts_regex)
  end

  before(:all) do
    WebMock.disable_net_connect!
  end
  
  describe '#login' do
    before do
      login_get.to_return(status: 200, body: auth_token_form)
    end
    
    context 'when logged in' do
      before { login_post.to_return(status: 302, headers: {location: bank_url}) }
      it 'should return true' do
        expect(client.login(credentials)).to eq true
      end
    end
    
    context 'when wrong redirection has been received' do
      before { login_post.to_return(status: 302, headers: {location: 'somewhere'}) }
      it 'should return false' do
        expect(client.login(credentials)).to eq false
      end
    end
    
    context 'when wrong status has been received' do
      before { login_post.to_return(status: 500) }
      it 'should return false' do
        expect(client.login(credentials)).to eq false
      end
    end
  end
  
  describe '#auth_token' do
    before do
      login_get.to_return(status: 200, body: auth_token_form)
    end
    it 'should return correct auth token' do
      expect(client.send(:auth_token)).to eq auth_token
    end
  end
  
  describe '#account' do
    context 'when not logged in' do
      it 'should raise error' do
        expect{client.accounts}.to raise_error('You must be logged in')
      end
    end
    
    context 'when logged in' do
      before { client.instance_variable_set(:@logged_in, true) }
      
      context 'when got accounts info' do
        let(:accounts_info) do
          [{:type=>:current, :balance=>1000085.5, :currency=>"BHD"},
          {:type=>:savings, :balance=>534599.0, :currency=>"USD"}]
        end
        before { accounts_get.to_return(status: 200, body: File.read('spec/accounts.html')) }
        it 'should return it in proper form' do
          expect(client.accounts).to eq accounts_info
        end
      end
      
      context 'when redirection has been received' do
        before { accounts_get.to_return(status: 302) }
        it 'should raise error' do
          expect{client.accounts}.to raise_error('You must be logged in')
        end
      end
      
      context 'when wrong status has been received' do
        before { accounts_get.to_return(status: 500) }
        it 'should raise error' do
          expect{client.accounts}.to raise_error("Can't get accounts info")
        end
      end
    end
  end
end
