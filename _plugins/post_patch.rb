require 'jekyll/post'

class Jekyll::Post
  EXCERPT_ATTRIBUTES_FOR_LIQUID.push :primary_category, :category_title, :category_url, :order_in_category

  def primary_category
    data["primary_category"] ||= categories.join
  end

  def category_title
    return unless site.data["category_params"]
    data["category_title"] ||= (site.data["category_params"][primary_category]||{})["title"]
  end

  def order_in_category
    return data["order_in_category"] if data["order_in_category"]
    urls = site.categories[primary_category].map(&:url)
    index = urls.index(url)
    return nil if index.nil?
    data["order_in_category"] = urls.size - index
  end

  def category_url
    return nil if category_title.nil?
    data["category_url"] ||= "/categories/#{primary_category}/index.html"
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

class Jekyll::Post
  EXCERPT_ATTRIBUTES_FOR_LIQUID.push :available_thumbnail

  def available_thumbnail
    data["available_thumbnail"] ||= data["thumbnail"]
    data["available_thumbnail"] ||= data["main_image"]
  end
end
