module GeoJSON
  # A `FeatureCollection` represents a [GeoJSON FeatureCollection object](https://tools.ietf.org/html/rfc7946#section-3.3)
  # and contains one or more `Feature`s.
  class FeatureCollection < Base
    include JSON::Serializable

    getter type : String = "FeatureCollection"
    # Returns this `FeatureCollections` array of features.
    getter features : Array(Feature)

    # Creates a new `FeatureCollection` with the given *features*.
    def initialize(@features : Array(Feature))
    end

    # Creates a new `FeatureCollection` with the given *features*.
    def initialize(*features : Feature)
      @features = features.to_a
    end

    def_equals_and_hash type, features
  end
end
