require 'faraday'
require 'faraday-cookie_jar'
require 'nokogiri'

class DemoBankClient
  VERSION = "0.1.0"
  BANK_URL = 'https://verify-demo-bank.herokuapp.com/'.freeze
  LOGIN_TIMEOUT = 20

  def initialize
    @conn = Faraday.new(url: BANK_URL) do |f|
      f.request :url_encoded
      f.use :cookie_jar
      f.adapter Faraday.default_adapter
    end
    @logged_in = false
  end

  def login(username:, password:)
    start_time = Time.now
    params = {
      utf8: '✓',
      authenticity_token: auth_token,
      email: username,
      password: password,
    }
    begin
      res = @conn.post('/login', params) { |req| req.options.timeout = LOGIN_TIMEOUT }
      case res.status
      when 400...600
        raise RuntimeError
      when 302
        @logged_in = (res.headers['location'] == BANK_URL)
      end
    rescue
      retry if Time.now - start_time < LOGIN_TIMEOUT
      return false
    end
  end

  def accounts
    raise 'You must be logged in' unless @logged_in

    res = @conn.get '/accounts'
    case res.status
    when 300...400
      @logged_in = false
      raise 'You must be logged in'
    when 400...600
      raise "Can't get accounts info"
    end

    values = Nokogiri::HTML(res.body).xpath('//table[2]/tbody/tr').map do |tr|
      tr.search('th, td').map(&:text)
    end
    values.map do |type, balance, currency|
      {
        type: type.downcase.to_sym,
        balance: balance.tr(',', '').to_f * 100,
        currency: currency
      }
    end
  end

  private

  def auth_token
    res = @conn.get('/login')
    Nokogiri::HTML(res.body).at('[name=authenticity_token]')['value']
  end
end
