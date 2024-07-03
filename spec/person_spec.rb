
require 'activitypub/types'

RSpec.describe ActivityPub::Person do

  context "actor.json fixture parsed with ActivityPub.from_json" do
    subject { ActivityPub.from_json(File.read("spec/fixtures/actor.json")) }

    it { is_expected.to be_instance_of(ActivityPub::Person) }

    context "when serialized" do
      it "should have a 'type' attribute matching 'Person'" do
        expect(subject.to_h.dig("type")).to eq "Person"
      end
    end

    it do
      is_expected.to have_attributes(
        :id => "https://mastodon.social/users/vidarh",
        :url => "https://mastodon.social/@vidarh",
        :preferredUsername => "vidarh",
        :outbox => "outbox.json",
        :likes => "likes.json",
        :bookmarks => "bookmarks.json",
        :discoverable => true,
        :manuallyApprovesFollowers => false,
        :summary => "my summary"
      )
    end

    it { expect(subject.tag).to be_kind_of(Array) }
  end
  
end
