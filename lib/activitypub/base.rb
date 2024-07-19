# frozen_string_literal: true

require 'json'

module ActivityPub
  class Error < StandardError; end

  
  def self.from_json(json, resolver: nil)
    from_hash(JSON.parse(json), resolver:)
  end

  def self.from_hash(h, resolver: nil)
    type = h&.dig("type")

    raise Error, "'type' attribute is required" if !type
    raise NameError, "'type' attribute with '::' is not allowed" if !type.index("::").nil?

    # FIXME: May need a way to override/handle custom namespaces.
    
    klass = ActivityPub.const_get(type)

    ob = klass ? klass.new : nil
    ob._resolver = resolver

    # FIXME: Useful for debug. Add flag to allow enabling.
    # ob.instance_variable_set("@_raw",h)
    
    if ob
      context = h.dig("@context")
      ob.instance_variable_set("@_context", context) if context
      
      klass.ap_attributes.each do |attr|
        v = h.dig(attr.to_s)

        if v.is_a?(Hash) && v["type"]
          v = from_hash(v)
        elsif v.is_a?(Array)
          v = v.map do |av|
            av.is_a?(Hash) && av["type"] ? from_hash(av) : av
          end
        end

        if t = klass.ap_types[attr]
          v = t.new(v) if v && !v.kind_of?(ActivityPub::Base)
          v._resolver = ob._resolver if v
        end
        ob.instance_variable_set("@#{attr}", v) if !v.nil?
      end
    end

    ob
  end
    
  # This is not part of ActivityPub, but provides basic mechanisms
  # for serialization and dezerialisation.
  #
  class Base
    def _context = @_context || "https://www.w3.org/ns/activitystreams"
    def _type = self.class.name.split("::").last

    attr_accessor :_resolver


    # FIXME: Allow specifying a type (e.g. URI)
    def self.ap_attr(name, type=nil)
      @ap_attributes ||= []
      @ap_attributes << name
      @ap_types ||= {}
      @ap_types[name] = type
      attr_accessor name
    end

    def self.ap_types
      parent = superclass.respond_to?(:ap_types) ? superclass.ap_types : {}
      parent.merge(@ap_types || {})
    end
    
    def self.ap_attributes
      parent = superclass.respond_to?(:ap_attributes) ? superclass.ap_attributes : []
      parent.concat(@ap_attributes||[])
    end

    def to_h
      h = {
        "@context" => _context,
        "type" => _type,
      }

      self.class.ap_attributes.each do |attr|
        val = instance_variable_get("@#{attr}")
        h[attr.to_s] = val if val
      end

      h
    end

    def to_json(...) = to_h.to_json(...)
  end


end
