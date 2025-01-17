
require 'uri'
require 'faraday'
require 'socket'
require 'ipaddr'

# Classes to resolve URI's into objects.


module ActivityPub

  class WebResolver
    def self.call(path)

      uri = URI(path)
      addr = IPAddr.new(IPSocket.getaddress(uri.host))
      if addr.loopback? || addr.private? || addr.link_local?
        raise "Local access denied"
      end
      
      response = Faraday.get(path, {}, {"Accept": "application/activity+json"})
      if response.status == 200
        ActivityPub.from_json(response.body)
      else
        response
      end
    end
  end

  #
  # UnsafeResolver supports filesystem references. It's named as it is to make
  # you stop and think. If you load remote objects and allow the use of UnsafeResolver,
  # it *will* try to load things from your filesystem. If you subsequently
  # allow access to that data in ways that are not strictly controlled, you run
  # the risk of a security hole.
  #
  # A future version will likely allow containing this to specific paths,
  # but currently it makes *NO ATTEMPTS* to sanitise paths, so paths including
  # ".." etc. will allow filesystem traversal.
  #
  class UnsafeResolver
    def initialize(base)
      @base = File.expand_path(base)
    end
    
    def call(path)
      path = File.expand_path(path,@base)
      raise "Illegal path" if path[0...@base.length] != @base
      if File.exist?(path)
        data = File.read(path)
        return ActivityPub.from_json(data)
      end
      WebResolver.call(path)
    end
  end
end
