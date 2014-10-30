require 'jekyll/post'

module WeightedRelatedPosts
  # Calculate related posts.
  #
  # Returns [<Post>]
  def related_posts(posts)
    return [] unless posts.size > 1
    highest_freq = tag_freq(posts).values.max
    related_scores = Hash.new(0)

    tag_weights = {}
    tags_size = tags.size
    tags.each_with_index { |tag, i|  tag_weights[tag] = 2 ** (tags_size - 1 - i) }

    posts.each do |post|
      next if post == self
      next if post.categories == self.categories
      next if post.categories.include?(self.data["sub_category"])
      post.tags.each do |tag|
        if self.tags.include?(tag)
          cat_freq = tag_freq(posts)[tag]
          related_scores[post] += (1 + highest_freq - cat_freq) * tag_weights[tag]
        end
      end
    end
    sort_related_posts(related_scores)
  end

  # Calculate the frequency of each tag.
  #
  # Returns {tag => freq, tag => freq, ...}
  def tag_freq(posts)
    return @tag_freq if @tag_freq
    @tag_freq = Hash.new(0)
    posts.each do |post|
      post.tags.each { |tag| @tag_freq[tag] += 1 }
    end
    @tag_freq
  end

  # Sort the related posts in order of their score and date
  # and return just the posts
  def sort_related_posts(related_scores)
    related_scores.sort do |a,b|
      if a[1] < b[1]
        1
      elsif a[1] > b[1]
        -1
      else
        b[0].date <=> a[0].date
      end
    end.collect { |post,freq| post }
  end

end

class Jekyll::Post
  remove_method :related_posts
  include WeightedRelatedPosts
end
