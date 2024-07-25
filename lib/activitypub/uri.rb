
require_relative 'resolvers'

module ActivityPub
  class URI
    attr_writer :_resolver

    def initialize(href, resolver: nil)
      @href = href
      @_resolver = resolver
    end

    def _resolver = (@_resolver || WebResolver)

    def to_s = @href
    def to_json(...) = @href
      
    def get = _resolver.call(self.to_s)
  end
end
