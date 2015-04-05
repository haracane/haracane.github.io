module ProperAdsReadable
  def proper_ads
    data['proper_ads'] ||= generate_proper_ads
  end

  private

  def valid_ad_freqs
    return @valid_ad_freqs if @valid_ad_freqs
    freqs = data['ad_freqs'] || site.config['ad_freqs'] || {'adsense' => 1}
    @valid_ad_freqs = freqs.select { |_category, freq| freq > 0 }
  end

  def generate_proper_ads
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
    ad_records = ad_records.shuffle.uniq { |ad| [ad['category'], ad['path']] }
    adsense_count = ad_records.select { |ad| ad['category'] == 'adsense' }.size
    (3 - adsense_count).times { ad_records << {'category' => 'adsense'} }
    ad_records
  end
end

class Jekyll::Post
  include ProperAdsReadable
  EXCERPT_ATTRIBUTES_FOR_LIQUID.push :proper_ads
end

class Jekyll::Page
  include ProperAdsReadable
  ATTRIBUTES_FOR_LIQUID.push :proper_ads
end
