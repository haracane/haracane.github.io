require 'jekyll/post'
require 'digest/md5'

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
    return nil if index.nil?
    data["order_in_category"] = urls.size - index
  end

  def category_url
    return nil if category_title.nil?
    data["category_url"] ||= "/categories/#{primary_category}/index.html"
  end
end

class Jekyll::Post
  EXCERPT_ATTRIBUTES_FOR_LIQUID.push :tag_urls, :tag_colors

  def tag_urls
    data["tag_urls"] ||= generate_tag_urls
  end

  def tag_colors
    data["tag_colors"] ||= generate_tag_colors
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

  def generate_tag_colors
    colors = {}

    tags.each do |tag|
      mark_colors = site.data['tag_colors'][tag] || site.data['tag_colors']['default']
      seed = Digest::MD5.hexdigest(tag).to_i(16)
      colors[tag] = mark_colors[seed % mark_colors.size]
    end

    colors
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

class Jekyll::Post
  EXCERPT_ATTRIBUTES_FOR_LIQUID.push :ads

  def ads
    data['ads'] ||= generate_ads
  end

  private

  def valid_ad_freqs
    return @valid_ad_freqs if @valid_ad_freqs
    freqs = data['ad_freqs'] || site.config['ad_freqs'] || {'adsense' => 1}
    @valid_ad_freqs = freqs.select { |_category, freq| freq > 0 }
  end

  def generate_ads
    ad_records = []
    ad_categories = valid_ad_freqs.keys
    site.data['ads'].select do |ad|
      next if ad['show'] == false
      next unless ad_categories.include?(ad['category'])
      if ad['path']
        filepath = "_includes/#{ad['path']}"
        next unless File.exists?(filepath)
        ad['content'] = File.read(filepath)
        if site.config['show_drafts']
          ad['content'] = ad['content']
        end
      end
      valid_ad_freqs[ad['category']].times { ad_records << ad }
    end
    ad_records.shuffle.uniq { |ad| [ad['category'], ad['path']] }
  end
end
