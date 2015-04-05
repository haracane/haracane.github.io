require 'digest/md5'

module Jekyll
  class TagColorsGenerator < Generator
    safe true
    priority :high

    def generate(site)
      colors = {}

      site.tags.each do |tag, post|
        mark_colors =
          site.data['tag_color_groups'][tag] ||
            site.data['tag_color_groups']['default']

        if mark_colors.is_a? String
          colors[tag] = mark_colors
          next
        end

        colors[tag] = mark_colors[Digest::MD5.hexdigest(tag).to_i(16) % mark_colors.size]
      end

      site.data['tag_colors'] = colors
    end
  end
end
