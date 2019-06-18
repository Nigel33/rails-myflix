# Elasticsearch::Model.client =
#   if Rails.env.staging? || Rails.env.production?
#     Elasticsearch::Client.new url: ENV['SEARCHBOX_URL']
#   elsif Rails.env.development?
#     Elasticsearch::Client.new log: true
#   else
#     Elasticsearch::Client.new
#   end



 config = {
  host: "http://localhost:9200/",
  transport_options: {
    request: { timeout: 5 }
  }
}

if File.exists?("config/elasticsearch.yml")
  config.merge!(YAML.load_file("config/elasticsearch.yml")[Rails.env].deep_symbolize_keys)
end

Elasticsearch::Model.client = Elasticsearch::Client.new(config)