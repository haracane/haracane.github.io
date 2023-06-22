require_relative "./post"
require_relative "./category"

POSTS = {
  "model-spec-custom-matchers" => "2014-10-30-model-spec-custom-matchers-index",
  "rails-capybara" => "2014-10-30-rails-capybara-index",
  "rails-restful" => "2014-10-30-rails-restful-index",
}

module Domains
  module CategoryLink
    def self.build(post)
      categories = post["categories"]
      return if categories.length == 0
      post["category_links"] = nil
      links = []
      categories.each do |category|
        name = Domains::Category.names[category]
        next if name.nil?
        post_slug = POSTS[category]
        next if post_slug.nil?

        links << "[#{Domains::Category.names[category]}]({% post_url #{post_slug} %})"
      end

      post["category_links"] = "連載: " + links.join(" / ") if links.length > 0
      Domains::Post.store(post)
    end

    def self.build_all
      Domains::Post.all.each { |post| build(post) }
    end
  end
end
