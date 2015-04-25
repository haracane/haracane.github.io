module Jekyll
  class TweetsGenerator < Generator
    WEIGHT_OF_HATENA = 2
    WEIGHT_OF_FACEBOOK = 1
    WEIGHT_OF_TWITTER = 1

    safe true
    priority :high

    def generate(site)
      return if site.config['watch']
      tweets = []
      twitter_config = site.config['twitter'] || {}
      filter_config = twitter_config['filter'] || {}

      site.posts.each do |post|
        filter_config.each do |key, value|
          case key
          when 'title'
            next unless post.title.include?(value)
          end
          tweets << "#{post.title} #{site.config['url']}#{post.url}"
        end
      end

      output_dir = '_twitter'

      Dir.mkdir(output_dir) unless Dir.exists?(output_dir)

      File.open("#{output_dir}/tweets.txt", 'w') do |file|
        tweets.each do |tweet|
          file.puts tweet
        end
      end
    end
  end
end
