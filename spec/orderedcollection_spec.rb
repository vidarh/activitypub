
require 'activitypub/types'

RSpec.describe ActivityPub::OrderedCollection do

  context "with orderedItem" do
    subject do
      o = ActivityPub::OrderedCollection.new
      o.orderedItems = [
        :first,
        :second
      ]
      o
    end

    it "should support #map" do
      expect(subject.map { _1.to_s + "!" }).to eq ["first!", "second!"]
    end
  end
  
  context "likes.json fixture parsed with ActivityPub.from_json" do
    subject { ActivityPub.from_json(File.read("spec/fixtures/likes.json")) }

    it { is_expected.to be_instance_of(ActivityPub::OrderedCollection) }

    context "when serialized" do
      it "should have a 'type' attribute matching 'OrderedCollection'" do
        expect(subject.to_h.dig("type")).to eq "OrderedCollection"
      end
    end

    it do
      is_expected.to have_attributes(
        :id => "likes.json",
        :totalItems => 2,
        :orderedItems => a_kind_of(Array)
      )
    end
  end
end
