

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
        :url => a_kind_of(ActivityPub::URI),
        :preferredUsername => "vidarh",
        :outbox => a_kind_of(ActivityPub::URI),
        :likes => a_kind_of(ActivityPub::URI),
        :bookmarks => a_kind_of(ActivityPub::URI),
        :discoverable => true,
        :manuallyApprovesFollowers => false,
        :summary => "my summary"
      )
    end

    it do
      is_expected.to have_attributes(
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

    it "has URI objects in the href property of the Hashtag's" do
      expect(subject.tag.first.href).to be_kind_of(ActivityPub::URI)
    end

    it "has two PropertyValue objects in the 'attachment' array" do
      expect(subject.attachment).to include(a_kind_of(ActivityPub::PropertyValue)).twice
    end
  end

  context "when _resolver is set to a WebResolver instance (default)" do
    it "will by default not allow access to localhost" do
      expect {
        ActivityPub.from_json(
          %{ { "type": "Person", "likes": "http://localhost/foo" } },
          resolver: ActivityPub::WebResolver
        ).likes.get
      }.to raise_exception(RuntimeError, "Local access denied")
    end

    it "will by default not allow access to 10.0.0.0/8" do
      expect {
        ActivityPub.from_json(
          %{ { "type": "Person", "likes": "http://10.0.0.1/foo" } },
          resolver: ActivityPub::WebResolver
        ).likes.get
      }.to raise_exception(RuntimeError, "Local access denied")
    end

    it "will by default not allow access to 169.254.0.0/16" do
      expect {
        ActivityPub.from_json(
          %{ { "type": "Person", "likes": "http://169.254.1.1/foo" } },
          resolver: ActivityPub::WebResolver
        ).likes.get
      }.to raise_exception(RuntimeError, "Local access denied")
    end
    
  end

  context "when _resolver is set to a UnsafeResolver instance" do
    subject {
      ActivityPub.from_json(
        File.read("spec/fixtures/actor.json"),
        resolver: ActivityPub::UnsafeResolver.new("spec/fixtures")
      )
    }

    it "will resolve a relative file path" do
      expect(subject.likes.get).to be_kind_of(ActivityPub::Collection)
    end

    it "will not allow reading absolute paths outside the specified base" do
      expect {
        ActivityPub.from_json(
          %{ { "type": "Person", "likes": "/etc/passwd" } },
          resolver: ActivityPub::UnsafeResolver.new("spec/fixtures")
        ).likes.get
      }.to raise_exception(RuntimeError, "Illegal path")
    end

    it "will not allow using '..' to escape the base path" do
      expect {
        ActivityPub.from_json(
          %{ { "type": "Person", "likes": "../../README.md" } },
          resolver: ActivityPub::UnsafeResolver.new("spec/fixtures")
        ).likes.get
      }.to raise_exception(RuntimeError, "Illegal path")
    end
  end
  
end
