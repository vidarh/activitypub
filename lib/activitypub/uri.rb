
require_relative 'resolvers'

module ActivityPub
  class URI
    attr_accessor :_resolver

    def initialize(href, resolver: nil)
      @href = href
      @_resolver = resolver || WebResolver
    end

    def to_s = @href
    def to_json(...) = @href

    def get
      @_resolver&.call(self.to_s)
    end
  end
end
