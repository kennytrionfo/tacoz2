module Locatable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    mapping do
      indexes :street_address
      indexes :city
      indexes :state
      indexes :coordinates, type: 'geo_point', lat_lon: true, normalize: false, validate: true
    end
  end


  module InstanceMethods
    def coordinates
      [latitude, longitude]
    end

    def as_indexed_json(options={})
      as_json(
        methods: [
          :coordinates,
          :address
        ]
      )
    end

  end

  module ClassMethods
    def search(params)
      es = __elasticsearch__
      definition = {
        query: {
          query_string: {
            query: params[:q],
            default_operator: 'AND'
          }
        }
      }
      definition.merge!({
        filter: {
          and: {
            geo_distance: {distance: "#{params[:distance]}mi", coordinates: params[:coordinates]}}
        }
      })

      response = es.search(definition)
      response
    end

  end

end
