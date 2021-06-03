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
end
