
# https://www.w3.org/TR/activitystreams-vocabulary/

require_relative 'base'

module ActivityPub

  class Link < Base
    ap_attr :href, :rel, :mediaType, :name, :hreflang, :height, :width, :preview
  end

  class Object < Base
    ap_attr :attachment, :attributedTo, :audience, :content, :context,
      :name, :endTime, :generator, :icon, :image, :inReplyTo, :location,
      :preview, :published, :replies, :startTime, :summary, :tag, :updated,
      :url, :to, :bto, :cc, :mediaType, :duration
  end

  class Activity < Object
    ap_attr :actor, :object, :target, :result, :origin, :instrument
  end

  # @FIXME
  #  All attributes from Activity *except* object.
  class IntransitiveActivity < Activity
  end

  class Collection < Object
    ap_attr :totalItems, :current, :first, :last, :items
  end

  class OrderedCollection < Collection
  end

  class CollectionPage < Collection
    ap_attr :partOf, :next, :prev
  end
  
  class OrderedCollectionPage < CollectionPage
    ap_attr :startIndex
  end

  # ## ActivityTypes

  class Accept < Activity
  end

  class TentativeAccept < Accept
  end

  class Add < Activity
  end

  class Arrive < IntransitiveActivity
  end

  class Create < Activity
  end

  class Delete < Activity
  end

  class Follow < Activity
  end

  class Ignore < Activity
  end

  class Join < Activity
  end

  class Leave < Activity
  end

  class Like < Activity
  end

  class Offer < Activity
  end

  class Invite < Offer
  end

  class Reject < Activity
  end

  class TentativeReject < Reject
  end

  class Remove < Activity
  end

  class Undo < Activity
  end

  class Update < Activity
  end

  class View < Activity
  end

  class Listen < Activity
  end

  class Move < Activity
  end

  class Travel < IntransitiveActivity
  end

  class Announce < Activity
  end

  class Block < Ignore
  end

  class Flag < Activity
  end

  class Dislike < Activity
  end

  class Question < IntransitiveActivity
    ap_attr :oneOf, :anyOf, :closed
  end

  # ## Actor Types

  # NOTE: *NOT* an ActivityPub object type
  # FIXME: Should probably not be possible to instantiate
  # directly.
  #
  class Actor < Object
    # Per https://www.w3.org/TR/activitypub/#actors
    # Section 4.1

    # MUST have:
    ap_attr :inbox, :outbox

    # SHOULD have:
    ap_attr :following, :followers
    
    # MAY have:
    ap_attr :liked, :streams, :preferredUsername,
      :endpoints


    # Per https://docs-p.joinmastodon.org/spec/activitypub/#extensions
    # These are extensions used by Mastodon for Actor types
    ap_attr :publicKey, :featured, :featuredTags,
      :discoverable, :suspended
  end

  # FIXME: Add "toot:Emoji
  # FIXME: Add PropertyValue
  
  class Application < Actor
  end

  class Group < Actor
  end

  class Person < Actor
  end

  class Service < Actor
  end

  
  # ## Object types

  class Relationship < Object
    ap_attr :subject, :object, :relationship
  end

  class Article < Object
  end

  class Document < Object
  end

  class Audio < Document
  end

  class Image < Document
    
    # Mastodon extension per
    # https://docs-p.joinmastodon.org/spec/activitypub/#extensions
    ap_attr :focalPoint, :blurhash
  end

  class Video < Document
  end

  class Note < Object
  end

  class Page < Object
  end

  class Event < Object
  end

  class Place < Object
  end

  class Mention < Link
  end

  class Profile < Object
  end

  class Tombstone < Object
    ap_attr :formerType, :deleted
  end
end
