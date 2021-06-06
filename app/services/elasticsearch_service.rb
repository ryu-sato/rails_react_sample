# Elasticsearch に関する Service
class ElasticsearchService

  # Elasticsearch に到達可能かを判別する
  def self.es_active?
    begin
      Elasticsearch::Model.client.cluster.health.present?
    rescue => exception
      return false
    end
  end

  # FullTextSearchable を include している全モデルの配列を返す
  # (ex. [Parent, Child, ...])
  def self.full_text_searchable_models
    tables = ActiveRecord::Base.connection.tables
    tables.map(&:classify).map(&:safe_constantize).compact.select { |c| c.included_modules.include? FullTextSearchable }
  end

  # FullTextSearchable を include しているモデルの属性名一覧を返す
  # (ex. [:name, :age, ...])
  def self.full_text_searchable_attributes
    models = full_text_searchable_models
    models.flat_map do |model|
      model.attribute_names.map(&:to_sym) - model.mappings.to_hash[:properties].select{|attr_name, mapping| mapping[:enabled] == false}.keys
    end
  end

  # Elasticsearch で検索する際のデフォルトオプション
  def self.default_search_option
    fields = full_text_searchable_attributes.map {|attr| [attr, {}]}.to_h
    {
      highlight: {
        pre_tags: ['<highlight>'],
        post_tags: ['</highlight>'],
        fields: fields
      },
      size: 300,
      sort: [
        :_score # スコアは特殊で高い順になる(https://www.elastic.co/guide/en/elasticsearch/reference/7.13/sort-search-results.html#sort-search-results)
      ]
    }
  end

  # Elasticsearch で正規表現で検索する
  def self.search_regex(searching_regex, option = nil)
    return nil if searching_regex.blank?

    # regexp クエリでは複数属性を検索できないため、bool で複数のクエリとして検索する
    # ref. https://stackoverflow.com/questions/52493339/elasticsearch-one-regexp-for-multiple-fields
    regexp = full_text_searchable_attributes.map {|attr| { regexp: { attr => searching_regex } } }
    query = {
      query: {
        bool: {
          should: regexp
        }
      }
    }.update(option || default_search_option).to_json
    models = full_text_searchable_models

    Elasticsearch::Model.search(
      query,
      models
    )
  end

  def self.search(searching_string, option = nil)
    return nil if searching_string.blank?

    searching_string = sanitize_string_for_elasticsearch_string_query(searching_string)
    query = {
      query: {
        simple_query_string: {
          query: searching_string,
          default_operator: :and
        }
      }
    }.update(option || default_search_option).to_json
    models = full_text_searchable_models

    Elasticsearch::Model.search(
      query,
      models
    )
  end

  # Lucene(Elasticsearch 内部) で予約されている特殊記号をエスケープするメソッド
  # 「*」(ワイルドカード)は例外的に使えるようにしている
  # refs: https://stackoverflow.com/a/16442439
  private_class_method def self.sanitize_string_for_elasticsearch_string_query(str)
    return "" if str.blank?

    # Escape special characters
    # http://lucene.apache.org/core/old_versioned_docs/versions/2_9_1/queryparsersyntax.html#Escaping Special Characters
    escaped_characters = Regexp.escape('\\/+-&|!(){}[]^~?:')
    str = str.gsub(/([#{escaped_characters}])/, '\\\\\1')
    # AND, OR and NOT are used by lucene as logical operators. We need
    # to escape them
    %w(AND OR NOT).each do |word|
      escaped_word = word.split('').map {|char| "\\#{char}" }.join('')
      str = str.gsub(/\s*\b(#{word.upcase})\b\s*/, " #{escaped_word} ")
    end
    # Escape odd quotes
    quote_count = str.count '"'
    str = str.gsub(/(.*)"(.*)/, '\1\"\3') if quote_count.odd?
    str
  end
end
