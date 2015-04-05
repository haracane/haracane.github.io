require 'net/http'
require 'json'

module SnsCountReadable
  def full_url
    site.config['url'] + url
  end

  def get_response_body(uri)
    return nil if site.config['show_drafts']
    begin
      Net::HTTP.get_response(URI.parse(uri)).body
    rescue StandardError
      nil
    end
  end

  def hatena_count
    return data['hatena_count'] if data['hatena_count']

    cache_key = 'hatena_counts'
    cached_count = fetch_cached_count(cache_key, full_url)

    data['hatena_count'] = cached_count[:value]
  end

  def facebook_count
    return data['facebook_count'] if data['facebook_count']

    cache_key = 'facebook_counts'
    cached_count = fetch_cached_count(cache_key, full_url)
    data['facebook_count'] = cached_count[:value]
  end

  def twitter_count
    return data['twitter_count'] if data['twitter_count']

    cache_key = 'twitter_counts'
    cached_count = fetch_cached_count(cache_key, full_url)
    data['twitter_count'] = cached_count[:value]
  end

  private

  def fetch_cached_count(cache_key, url)
    site.data['cache'] ||= {}
    site.data['cache'][cache_key] ||= {}
    cached_count = site.data['cache'][cache_key][full_url] || {}
    cached_count[:expired] =
      cached_count[:expires_at].nil? || Time.parse(cached_count[:expires_at]) < Time.now
    cached_count[:value] ||= 0

    if cached_count[:expired]
      latest_value = nil

      case cache_key
      when 'hatena_counts'
        uri = "http://api.b.st-hatena.com/entry.count?url=#{full_url}"
        body = get_response_body(uri)
        latest_value = body && body.to_i
        cached_count[:expires_at] = Time.now + 60 * 10
      when 'facebook_counts'
        uri = "http://graph.facebook.com/#{full_url}"
        body = get_response_body(uri)
        latest_value = body && JSON.parse(body)['shares']
        cached_count[:expires_at] = Time.now + 60 * 60 * 24
      when 'twitter_counts'
        uri = "http://urls.api.twitter.com/1/urls/count.json?url=#{full_url}"
        body = get_response_body(uri)
        latest_value = body && JSON.parse(body)['count']
        cached_count[:expires_at] = Time.now + 60 * 10
      end

      cached_count[:value] = latest_value || cached_count[:value]

      save_cache_on_update(cache_key, url, cached_count)
    end

    cached_count
  end

  def save_cache_on_update(cache_key, url, cached_count)
    site.data['cache'][cache_key][url] = cached_count
    return if site.config['watch']
    File.write('_data/cache.json', site.data['cache'].to_json)
  end
end

class Jekyll::Post
  EXCERPT_ATTRIBUTES_FOR_LIQUID.push :hatena_count, :facebook_count, :twitter_count
  include SnsCountReadable
end
