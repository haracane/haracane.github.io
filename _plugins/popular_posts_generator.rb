module Jekyll
  class PopularPostsGenerator < Generator
    WEIGHT_OF_HATENA = 2
    WEIGHT_OF_FACEBOOK = 1
    WEIGHT_OF_TWITTER = 1

    safe true
    priority :high

    def generate(site)
      popular_posts = []
      posts_with_score = []

      begin
        site.posts.each do |post|
          score =
            WEIGHT_OF_HATENA * post.hatena_count +
            WEIGHT_OF_FACEBOOK * post.facebook_count +
            WEIGHT_OF_TWITTER * post.twitter_count

          posts_with_score << {"post" => post, "score" => score}
          puts "finished loading #{post.title} ..#{score}: #{post.hatena_count} hatena bookmarks, #{post.facebook_count} facebook likes & shares, #{post.twitter_count} tweets"
        end

        posts_with_score.sort_by{|val| val['score']}.reverse_each do |entry|
          popular_posts << entry['post']
        end

      rescue StandardError
        popular_posts = site.posts.reverse
      end

      popular_posts

      site.data['popular_posts'] = popular_posts
    end
  end
end
