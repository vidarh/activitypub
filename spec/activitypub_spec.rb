
require 'activitypub/base'

RSpec.describe ActivityPub do
  context "#from_json" do
    it "should raise JSON::ParserError exception if JSON parsing fails" do
      expect { ActivityPub.from_json("}{") }.to raise_error(JSON::ParserError)
    end

    it "should raise an exception if the object does not contain a 'type' attribute" do
      expect { ActivityPub.from_json("{}") }.to raise_error(ActivityPub::Error)
    end

    it "should return an ActivityPub::<class> if at least 'type' is present and matching a class in the ActivityPub module" do
      expect(ActivityPub.from_json(%{ { "type": "Object" } }).class).to eq ActivityPub::Object
      expect(ActivityPub.from_json(%{ { "type": "Activity" } }).class).to eq ActivityPub::Activity
    end

    it "should default to raise an exception if the object contains a type that does not match a known object type" do
      expect { ActivityPub.from_json(%{ { "type": "ThisTypeIsInvalid" } }) }.to raise_error(NameError)
    end

    # We don't want type ability to pass e.g. "type": "::SomeClassYouShouldntAccess"
    it "should raise an exception if the object contains a 'type' field with '::' even if it matches a class" do
      expect { ActivityPub.from_json(%{ { "type": "::Object" } }) }.to raise_error(NameError)
    end

    it "should return a generic ActivityPub::Object if the object contains an unknown type and 'allow_uknown: true' is passed" do
      expect(ActivityPub.from_json(%{ { "type": "FooBar" } }, allow_unknown: true).class).to eq ActivityPub::Object
    end

    it "should return an object which will return a JSON hash from #_raw" do
      expect(ActivityPub.from_json(%{ { "type": "Object", "foo": "bar" } })._raw["foo"]).to eq "bar"
    end
  end
end

