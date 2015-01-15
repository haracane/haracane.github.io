require 'net/http'
require 'json'

WEIGHT_OF_HATENA = 2
WEIGHT_OF_FACEBOOK = 1
WEIGHT_OF_TWITTER = 1

class Jekyll::Post
  EXCERPT_ATTRIBUTES_FOR_LIQUID.push :hatena_count, :facebook_count, :twitter_count

  def full_url
    site.config['url'] + url
  end

  def get_response_body(uri)
    begin
      Net::HTTP.get_response(URI.parse(uri)).body
    rescue StandardError
      nil
    end
  end

  def hatena_count
    return data['hatena_count'] if data['hatena_count']
    uri = "http://api.b.st-hatena.com/entry.count?url=#{full_url}"

    body = get_response_body(uri)
    data['hatena_count'] = body && body.to_i || 0
  end

  def facebook_count
    return data['facebook_count'] if data['facebook_count']
    uri = "http://graph.facebook.com/#{full_url}"

    body = get_response_body(uri)
    data['facebook_count'] = body && JSON.parse(body)['shares'] || 0
  end

  def twitter_count
    return data['twitter_count'] if data['twitter_count']
    uri = "http://urls.api.twitter.com/1/urls/count.json?url=#{full_url}"

    body = get_response_body(uri)
    data['twitter_count'] = body && JSON.parse(body)['count'] || 0
  end
end

module Jekyll
  class RankingGenerator < Generator
    safe true
    priority :high

    def generate(site)
      @posts, posts_with_score = [], []

      begin
        site.posts.each do |post|
          if site.config['show_drafts']
            post.data['hatena_count'] = rand(100)
            post.data['facebook_count'] = rand(100)
            post.data['twitter_count'] = rand(100)
          end

          score =
            WEIGHT_OF_HATENA * post.hatena_count +
            WEIGHT_OF_FACEBOOK * post.facebook_count +
            WEIGHT_OF_TWITTER * post.twitter_count

          posts_with_score << {"post" => post, "score" => score}
          puts "finished loading #{post.title} ..#{score}: #{post.hatena_count} hatena bookmarks, #{post.facebook_count} facebook likes & shares, #{post.twitter_count} tweets"
        end

        posts_with_score.sort_by{|val| val['score']}.reverse_each do |entry|
          @posts << entry['post']
        end

      rescue StandardError
        @posts = site.posts.reverse
      end

      site.data['popular_posts'] = @posts
    end

  end
end
