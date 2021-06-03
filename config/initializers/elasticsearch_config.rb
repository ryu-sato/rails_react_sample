config = {
  host: "http://localhost:9200",
  transport_options: {
    request: { timeout: 90 }
  },
}

if File.exists?("config/elasticsearch.yml")
  yml_config = YAML.load_file("config/elasticsearch.yml").deep_symbolize_keys
  environment = ENV['RAILS_ENV'].present? ? ENV['RAILS_ENV'].to_sym : :development
  c = yml_config[environment].present? ? yml_config[environment] : {}
  config.merge!(c)
end

Elasticsearch::Model.client = Elasticsearch::Client.new(config)
