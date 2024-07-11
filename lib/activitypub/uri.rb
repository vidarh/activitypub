
require 'uri'
require 'faraday'

module ActivityPub
  class URI
    def initialize(href)
      @href = href
    end

    def to_s = @href
    def to_json = @href

    def get
      response = Faraday.get(self.to_s, {}, {"Accept": "application/activity+json"})
      if response.status == 200
        ActivityPub.from_json(response.body)
      else
        response
      end
    end
  end
end
