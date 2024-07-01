
module ActivityPub

  # This is not part of ActivityPub, but provides basic mechanisms
  # for serialization and dezerialisation.
  #
  class Base
    def _context = "https://www.w3.org/ns/activitystreams"
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
