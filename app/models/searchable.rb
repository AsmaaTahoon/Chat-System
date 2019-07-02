module Searchable
  extend ActiveSupport::Concern
  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    index_name [Rails.application.engine_name, Rails.env].join('_')

    settings index: { number_of_shards: 3, number_of_replicas: 0} do
    mapping do
      indexes :chat
    end
    def as_indexed_json(options={})
      hash = self.as_json()
      hash['chat'] = self.chat
      hash
    end

    def self.search(query, options={})
      __set_filters = lambda do |key, f|
        @search_definition[:post_filter][:and] ||= []
        @search_definition[:post_filter][:and]  |= [f]
      end

      @search_definition = {
        query: {},

        highlight: {
          pre_tags: ['<em class="label label-highlight">'],
          post_tags: ['</em>'],
          fields: {
            title: {number_of_fragments: 0}
          }
        },
        post_filter: {},

        aggregations: {
          chat: {
            filter: {bool: {must: [match_all: {}]}},
            aggregations: {chat: {terms: {field: 'chat'}}}
          }
        }
      }

      unless query.blank?
        @search_definition[:query] = {
          bool: {
            should: [
              {
                multi_match: {
                  query: query,
                  fields: ['title^10'],
                  operator: 'and'
                }
              }
            ]
          }
        }
      else
        @search_definition[:query] = { match_all: {} }
       end

       if options[:chat]
        f = {term: { chat: options[:taxon]}}
       end
       __elasticsearch__.search(@search_definition)
     end
    end
  end
end
