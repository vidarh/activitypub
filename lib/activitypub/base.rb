# frozen_string_literal: true

require 'json'

module ActivityPub
  class Error < StandardError; end
  
  def self.from_json(json)
    h = JSON.parse(json)
    type = h&.dig("type")

    raise Error, "'type' attribute is required" if !type
    raise NameError, "'type' attribute with '::' is not allowed" if !type.index("::").nil?

    # FIXME: May need a way to override/handle custom namespaces.
    
    klass = ActivityPub.const_get(type)

    ob = klass ? klass.new : nil

    if ob
      context = h.dig("@context")
      ob.instance_variable_set("@_context", context) if context
      
      klass.ap_attributes.each do |attr|
        ob.instance_variable_set("@#{attr}", h.dig(attr.to_s))
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


    def self.ap_attr(*names)
      @ap_attributes ||= []
      @ap_attributes.concat(names)
      attr_accessor *names
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
