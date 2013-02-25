module INWX
  class INWX
    def initialize(configatron)
      @configatron = configatron
    end

    def ensure_host
      return unless binding

      puts "Checking INWX domain #{binding[:host]}"
      login

      found_host = find_host nameserver_info
      if found_host
        puts "Host #{binding[:host]} is already registered"
        return
      end

      puts "Creating #{binding[:host]}"
      robot.call("nameserver", "createRecord", nameserver_info)
    end

    def remove_host
      return unless binding

      puts "Checking INWX domain #{binding[:host]}"
      login

      found_host = find_host nameserver_info
      unless found_host
        puts "Host #{binding[:host]} is not registered"
        return
      end

      puts "Deleting #{binding[:host]} with ID #{found_host["id"].to_i}"
      robot.call("nameserver", "deleteRecord", { :id => found_host["id"].to_i })
    end

    private
    def robot
      @robot ||= ::INWX::Domrobot.new("api.domrobot.com")
    end

    def login
      puts "Logging in"
      robot.login(@configatron.roles.web.inwx.user, @configatron.roles.web.inwx.password.to_s)
    end

    def nameserver_info
      {
        :domain => "devopenspace.de",
        :type => "CNAME",
        :name => binding[:host],
        :content => @configatron.deployment.connection.server
      }
    end

    def find_host(nameserver_info)
      puts "Retrieving available domains"
      # Thanks to the crappy INWX API we don't get zero elements if nothing was found, but an 2303 error code.
      # So we broaden our search to get something back and search a second time on our own.
      hosts = robot.call("nameserver", "info", nameserver_info.reject { |k, _| k == :name || k == :content })

      hosts["resData"]["record"].find do |record|
        record["content"] == nameserver_info[:content] &&
        record["name"] == nameserver_info[:name]
      end
    end

    def binding
      b = @configatron.roles.web.deployment.bindings.first
      unless b[:host] =~ /.+\.beta\.devopenspace\.de$/
        warn "An attempt was made to change INWX DNS for the non-beta domain '#{b[:host]}'. Skipping."
        return nil
      end
      b
    end
  end
end
