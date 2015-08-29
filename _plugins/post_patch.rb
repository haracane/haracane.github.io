require 'jekyll/post'

class Jekyll::Post
  EXCERPT_ATTRIBUTES_FOR_LIQUID.push(
    :primary_category,
    :category_title,
    :category_url,
    :order_in_category,
    :updated_at
  )

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
    # require 'pry'; binding.pry
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
    data["tag_urls"] ||= generate_tag_urls
  end

  private

  def generate_tag_urls
    site_tag_urls = site.data["tag_urls"]
    urls = {}
    tags.each do |tag|
      if tag =~ /^[a-zA-Z0-9_-]+$/
        urls[tag] = "/tags/#{tag.downcase}/"
      else
        urls[tag] = site_tag_urls[tag]
      end
    end
    urls
  end
end

class Jekyll::Post
  EXCERPT_ATTRIBUTES_FOR_LIQUID.push :available_thumbnail

  def available_thumbnail
    data["available_thumbnail"] ||= data["thumbnail"]
    data["available_thumbnail"] ||= data["main_image"]
  end
end

class Jekyll::Post
  EXCERPT_ATTRIBUTES_FOR_LIQUID.push :updated_at

  def updated_at
    data['updated_at'] ||= data['updated_at_text'] && Time.parse(data['updated_at_text'])
  end
end
