
# https://www.w3.org/TR/activitystreams-vocabulary/

require_relative 'base'
require_relative 'uri'

module ActivityPub

  class Link < Base
    ap_attr :href, URI

    # We don't mark "rel" as a URI as it's effectively
    # used as an identifier for comparison rather than to
    # dereference
    ap_attr :rel

    ap_attr :mediaType
    ap_attr :name
    ap_attr :hreflang
    ap_attr :height
    ap_attr :width
    ap_attr :preview
  end

  class Object < Base
    ap_attr :id
    ap_attr :attachment
    ap_attr :attributedTo
    ap_attr :audience
    ap_attr :content
    ap_attr :context
    ap_attr :name
    ap_attr :endTime
    ap_attr :generator
    ap_attr :icon
    ap_attr :image
    ap_attr :inReplyTo, URI
    ap_attr :location
    ap_attr :preview
    ap_attr :published
    ap_attr :replies
    ap_attr :startTime
    ap_attr :summary
    ap_attr :tag
    ap_attr :updated
    ap_attr :url, URI
    ap_attr :to
    ap_attr :bto
    ap_attr :cc
    ap_attr :mediaType
    ap_attr :duration
  end

  class Activity < Object
    ap_attr :actor
    ap_attr :object
    ap_attr :target
    ap_attr :result
    ap_attr :origin
    ap_attr :instrument
  end

  # @FIXME
  #  All attributes from Activity *except* object.
  class IntransitiveActivity < Activity
  end

  class Collection < Object
    ap_attr :totalItems
    ap_attr :current
    ap_attr :first, URI
    ap_attr :last, URI
    ap_attr :items

    def each(...) = Array(items).each(...)
    def map(...) = Array(items).map(...)
  end

  class OrderedCollection < Collection
    # "orderedItems" is not part of
    # https://www.w3.org/TR/activitystreams-vocabulary/#dfn-orderedcollection,
    # however it is part of at least some Mastodon exports, and so we include
    # it here
    #
    # FIXME: Review/consider whether to marge orderedItems/items internally.
    ap_attr :orderedItems

    def each(...) = Array(orderedItems).each(...)
    def map(...) = Array(orderedItems).map(...)
  end

  class CollectionPage < Collection
    ap_attr :partOf, URI
    ap_attr :next, URI
    ap_attr :prev, URI
  end

  # FIXME: OrderedCollectionPage inherits both CollectionPage and
  # OrderedCollection.
  #
  class OrderedCollectionPage < OrderedCollection
    ap_attr :partOf, URI
    ap_attr :next, URI
    ap_attr :prev, URI
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
    ap_attr :oneOf
    ap_attr :anyOf
    ap_attr :closed
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
    ap_attr :inbox, URI
    ap_attr :outbox, URI

    # SHOULD have:
    ap_attr :following
    ap_attr :followers
    
    # MAY have:
    ap_attr :liked
    ap_attr :streams
    ap_attr :preferredUsername
    ap_attr :endpoints


    # Per https://docs-p.joinmastodon.org/spec/activitypub/#extensions
    # These are extensions used by Mastodon for Actor types
    ap_attr :publicKey
    ap_attr :featured
    ap_attr :featuredTags
    ap_attr :discoverable
    ap_attr :suspended
  end

  # FIXME: Add "toot:Emoji
  # FIXME: Add PropertyValue
  
  class Application < Actor
  end

  class Group < Actor
  end

  class Person < Actor

    # Mastodon extension per
    # https://docs-p.joinmastodon.org/spec/activitypub/#extensions
    ap_attr :likes
    ap_attr :bookmarks
    ap_attr :manuallyApprovesFollowers
  end

  class Service < Actor
  end

  
  # ## Object types

  class Relationship < Object
    ap_attr :subject
    ap_attr :object
    ap_attr :relationship
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
    ap_attr :focalPoint
    ap_attr :blurhash
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
    ap_attr :formerType
    ap_attr :deleted
  end

  # Mastodon extensions

  class Hashtag < Link
  end

  class PropertyValue < Object
    ap_attr :value
  end
end
