module API
  module V1
    class SearchController < APIBaseController
      def full_text
        render json: {} && return if params[:q].blank?

        search_response = if params[:regexp] === "true"
                            ElasticsearchService.search_regex(params[:q])
                          else
                            ElasticsearchService.search(params[:q])
                          end
        @hit_records = search_response.map(&:_source).map(&:to_hash)
        @highlights = search_response.results.select {|result| result.try(:highlight)} .map do |result|
          result.highlight.transform_keys{ |k| k.sub(/\.\w/, '') }
        end
      end
    end
  end
end
