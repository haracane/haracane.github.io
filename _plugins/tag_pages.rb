class TagPage < Jekyll::Page
  def initialize(site, base, dir, tag, posts)
    @site = site
    @base = base
    @dir = dir
    @name = "index.html"

    self.process(@name)
    self.read_yaml(File.join(base, '_layouts'), 'tag.html')
    self.data['title'] = "「#{tag}」に関する記事"
    self.data['tag'] = tag
    self.data['posts'] = posts
  end
end

module TagPages
  class Generator < Jekyll::Generator
    safe true

    def generate(site)
      return unless site.layouts.key? "tag"
      tag_urls = site.data["tag_urls"]

      site.tags.each_pair do |tag, posts|
        if tag =~ /^[a-zA-Z0-9_-]+$/
          tag_url = "/tags/#{tag.downcase.gsub(/ /, "-")}/"
        else
          tag_url = tag_urls[tag]
        end

        next unless tag_url
        site.pages << TagPage.new(site, site.source, tag_url, tag, posts)
      end
    end
  end
end