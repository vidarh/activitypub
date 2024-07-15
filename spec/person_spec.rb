

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
    it "has a complex @context (returned via #_context)" do
      expect(subject._context).to include("https://www.w3.org/ns/activitystreams",
        "https://w3id.org/security/v1")
    end
      
    it do
      is_expected.to have_attributes(
        :id => "https://mastodon.social/users/vidarh",
        :url => "https://mastodon.social/@vidarh",
        :preferredUsername => "vidarh",
        :outbox => a_kind_of(ActivityPub::URI),
        :likes => "likes.json",
        :bookmarks => "bookmarks.json",
        :discoverable => true,
        :manuallyApprovesFollowers => false,
        :summary => "my summary",

        # Note: Currently, the types returned will reflect the input
        # document. We do NOT validate the types of these, and so
        # this reflects this fixture, which is typical for a Mastodon
        # export, but is *not* guaranteed to be what you will get

        :publicKey => a_kind_of(Hash),
        :tag => a_kind_of(Array),
        :attachment => a_kind_of(Array),
        :endpoints => a_kind_of(Hash),
        :icon => a_kind_of(ActivityPub::Image),
        :image => a_kind_of(ActivityPub::Image),
      )
    end

    it "has two Hashtag objects in the tag array" do
      expect(subject.tag).to include(a_kind_of(ActivityPub::Hashtag)).twice
    end

    it "has two PropertyValue objects in the 'attachment' array" do
      expect(subject.attachment).to include(a_kind_of(ActivityPub::PropertyValue)).twice
    end
  end
  
end
