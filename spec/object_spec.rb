
require 'activitypub/types'

RSpec.describe ActivityPub::Object, "#to_h" do
  context "with no attributes set" do
    it "should include the default ActivityStreams namespace" do
      h = ActivityPub::Object.new.to_h
      expect(h["@context"]).to eq "https://www.w3.org/ns/activitystreams"
    end

    it "should include a 'type' field set to Object" do
      expect(ActivityPub::Object.new.to_h["type"]).to eq "Object"
    end

    it "should have no other keys" do
      expect(ActivityPub::Object.new.to_h.keys).to eq ["@context","type"]
    end
  end
end
