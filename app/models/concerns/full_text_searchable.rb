# Elasticsearch による検索を有効にする
# 使い方
# Model < ActiveRecord::base
#   include FullTextSearchable
#   
#   # optional
#   # search_indeing_attributes
# end
module FullTextSearchable
  extend ActiveSupport::Concern
  
  ES_SETTINGS = {
    analysis: {
      analyzer: {
        kuromoji: {
          tokenizer: :kuromoji_tokenizer,
          char_filter: %i[icu_normalizer]
        },
        ngram: {
          tokenizer: :ngram,
          char_filter: %i[icu_normalizer]
        }
      }
    }
  }

  ANALYZER_SETTINGS = {
    raw: {
      type: :text,
      analyzer: :keyword
    },
    ngram: {
      type: :text,
      analyzer: :ngram
    },
    kuromoji: {
      type: :text,
      analyzer: :kuromoji
    }
  }

  included do
    include Elasticsearch::Model

    # 引数で指定した attribute だけ index する
    def self.attr_indexer(*indexed_attrs)
      indexed_attrs = indexed_attrs.map(&:to_sym)
      all_attrs = self.attribute_names.map(&:to_sym)
      raise "All of #{indexed_attrs} must be includeded in #{all_attrs}" unless indexed_attrs.all?{|a| all_attrs.include?(a) }

      mapping_attrs(indexed_attrs) do |attr|
        mappings do
          indexes attr, fields: ANALYZER_SETTINGS
        end
      end

      no_indexed_attrs = all_attrs - indexed_attrs
      mapping_attrs(no_indexed_attrs) do |attr|
        mappings do
          indexes attr, enabled: false, type: "object"
        end
      end
    end

    # Elasticsearch が起動しているときのみ、エンティティのアップデートを行うため、
    # include Elasticsearch::Model::Callbacks の代わりに定義している
    after_commit on: [:create, :update] do
      __elasticsearch__.index_document if ElasticsearchService.es_active?
    end

    after_commit on: [:destroy] do
      begin
        __elasticsearch__.delete_document if ElasticsearchService.es_active?
      rescue Elasticsearch::Transport::Transport::Errors::NotFound
        # ドキュメントが存在しない(すでに削除済みの)時には例外を出力しないようにする
      end
    end
    
    private_class_method

    def self.mapping_attrs(attrs, &mapping_block)
      raise 'blcok is required' unless mapping_block

      attrs.each do |attr|
        settings ES_SETTINGS do
          begin
            mapping_block.call(attr)
          rescue => exception
            # workaround: https://github.com/activeadmin/activeadmin/issues/783
            true
          end
        end
      end
    end
  end
end
