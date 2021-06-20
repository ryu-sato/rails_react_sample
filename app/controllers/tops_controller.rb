class TopsController < ApplicationController
  def index
  end
  
  # GET /tops or /tops.json
  def parent
    @parents_json = ParentSerializer.new(Parent.all).serializable_hash.to_json
  end

  def search
    unless ElasticsearchService.es_active?
      @hit_records = []
      @highlights = []

      return
    end

    # Kaminari の paginate メソッドにページャの情報(total_page など)を渡すために @search_results に格納する
    search_response = if params[:q].present?
                        ElasticsearchService.search(params[:q])
                      else
                        ElasticsearchService.search_regex(params[:regex_q])
                      end
    @hit_records = search_response.records
    @highlights = search_response.results.select {|result| result.try(:highlight) } .map do |result|
      # Elasticsearch の highlight が以下のような形式でレスポンスされるため
      # suffix を取り払って、attribute 名で解決できるようにする
      # highlight: {
      #   "titleized_class_name.japanase": [
      #     "<highlight>word1</highlight> <highlight>word2</highlight>"
      #   ],
      #   "title.english": [
      #     "some<highlight>name</highlight>_1"
      #   ]
      # }
      result.highlight.transform_keys{ |k| k.sub(/\.\w/, '') }
    end
  end
end
