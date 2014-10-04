require 'jekyll/post'

class Jekyll::Post
  EXCERPT_ATTRIBUTES_FOR_LIQUID.push :full_title, :full_title_before_site_title

  def binding_pry
    #require "pry"; binding.pry
  end

  def full_title
    full_title = title
    if data["category_title"]
      full_title = "#{data["category_title"]}：#{full_title}"
    end
    data["full_title"] = full_title
  end

  def full_title_before_site_title
    data["full_title_with_site_title"] = "#{full_title} | "
  end
end


class Jekyll::Post
  EXCERPT_ATTRIBUTES_FOR_LIQUID.push :tag_urls

  def tag_urls
    site_tag_urls = site.data["tag_urls"]
    tag_urls = {}
    tags.each do |tag|
      if tag =~ /^[a-zA-Z0-9_-]+$/
        tag_urls[tag] = "/tags/#{tag.downcase}/"
      else
        tag_urls[tag] = site_tag_urls[tag]
      end
    end
    data["tag_urls"] = tag_urls
  end
end
