Rails.application.configure do
  config.redis_cache = ENV["REDIS_URL"] ? Redis.new(url: ENV["REDIS_URL"]) : nil
end