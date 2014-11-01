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

  def hatena_count
    return data['hatena_count'] if data['hatena_count']
    uri = "http://api.b.st-hatena.com/entry.count?url=#{full_url}"

    body = Net::HTTP.get_response(URI.parse(uri)).body
    hatena_count = body.to_i
    data['hatena_count'] = hatena_count
  end

  def facebook_count
    return data['facebook_count'] if data['facebook_count']
    uri = "http://graph.facebook.com/#{full_url}"

    body = Net::HTTP.get_response(URI.parse(uri)).body
    json = JSON.parse(body)
    facebook_count = json['shares'] || 0
    data['facebook_count'] = facebook_count
  end

  def twitter_count
    return data['twitter_count'] if data['twitter_count']
    uri = "http://urls.api.twitter.com/1/urls/count.json?url=#{full_url}"

    body = Net::HTTP.get_response(URI.parse(uri)).body
    json = JSON.parse(body)
    twitter_count = json['count'] || 0
    data['twitter_count'] = twitter_count
  end
end

module Jekyll
  class RankingGenerator < Generator

    safe true
    priority :high

    def generate(site)
      @posts, @posts_with_score = [], []

      # 強引だけどここでオフライン検知
      begin
        #status is online

        # --draftsオプションを含めてビルドした場合も取得しない
        if site.config['show_drafts']
          raise
        end

        site.posts.each do |post|
          score = 0

          score =
            WEIGHT_OF_HATENA * post.hatena_count +
            WEIGHT_OF_FACEBOOK * post.facebook_count +
            WEIGHT_OF_TWITTER * post.twitter_count

          @posts_with_score << {"post" => post, "score" => score}
          puts "finished loading #{post.title} ..#{score}: #{post.hatena_count} hatena bookmarks, #{post.facebook_count} facebook likes & shares, #{post.twitter_count} tweets"
        end

        ## sort
        @posts_with_score.sort_by{|val| val['score']}.reverse.each do |entry|
          @posts << entry['post']
        end

      rescue
        # status is offline
        @posts = site.posts.reverse
      end

      site.data['popular_posts'] = @posts
    end

  end
end
