class ApplicationController < ActionController::API
  include Response
  include Error::ErrorHandler

  def initialize_cache
    @cache = ActiveSupport::Cache::RedisCacheStore.new
  end

  def invalidate_cache(key_name)
    @cache.delete(key_name)
  end
end
