require "xmlrpc/client"
require "yaml"

class XMLRPC::Client
  # WEAK: Enrich the client with a method for disabling SSL certificate verification
  # See /usr/lib/ruby/1.9.1/xmlrpc/client.rb:324
  # Bad hack but it works
  def disable_ssl_verification
    @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    warn "SSL certificate verification disabled"
  end
end

module INWX
  class Domrobot
    def initialize(address)
      @client = XMLRPC::Client.new(address, "/xmlrpc/", 443, nil, nil, nil, nil, true)
      @client.disable_ssl_verification
    end

    def login(username, password, language = 'en')
      raise "Cannot login to INWX API without a user name and password" unless username && password

      params = { :user => username, :pass => password, :lang => language }

      call("account", "login", params)
    end

    def logout
      call("account", "logout")
    end

    def call(object, method, params = { })
      result = @client.call(object + "." + method, params)
      response_code = result["code"].to_i

      raise "INWX RPC call failed\n#{YAML::dump(result)}" if response_code < 1000 || response_code > 1999

      result
    end
  end
end
