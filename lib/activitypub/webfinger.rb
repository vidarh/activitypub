
require 'webfinger'

module ActivityPub
  class WebFingerResult
    def initialize(hash)
      @h = hash

      @h["aliases"] = @h["aliases"].map{ ActivityPub::URI.new(_1) }
      @h["links"].each do |v|
        if v["href"]
          v["href"] = ActivityPub::URI.new(v["href"])
        end
      end
    end

    def[](i) = @h[i]

    def activitypub
      @activitypub ||= self["links"].find{ _1["rel"] == "self" && _1["type"] == "application/activity+json" }&.dig("href")
    end
  end
  
  def self.webfinger(acct)
    WebFingerResult.new(WebFinger.discover!(acct))
  end
end
