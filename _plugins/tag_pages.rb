class TagPage < Jekyll::Page
  def initialize(site, base, dir, tag, posts)
    @site = site
    @base = base
    @dir = dir
    @name = ""

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

    TAG_LINK_BOXES_PATH = '_data/tag_link_boxes.json'

    def tag_link_params
      @tag_link_params ||=
        JSON.parse(File.read(TAG_LINK_BOXES_PATH)) rescue {}
    end

    def generate(site)
      return unless site.layouts.key? "tag"
      tag_urls = site.data["tag_urls"]
      site_url = site.config['url']

      site.tags.each_pair do |tag, posts|
        if tag =~ /^[a-zA-Z0-9_-]+$/
          tag_url = "/tags/#{tag.downcase.gsub(/ /, "-")}/"
        else
          tag_url = tag_urls[tag]
        end

        tag_link_params[tag] ||= {}
        tag_link_params[tag].update('title' => "#{tag}についてのおすすめ記事")

        links = tag_link_params[tag]['links'] || []
        links = links.reject { |link| link['url'].include?(site_url) }

        posts.each do |post|
          next unless post.type == :posts
          links.push(
            'title' => post.title,
            'url' => "#{site_url}#{post.url}",
            'date' => post.date.strftime('%Y/%m/%d')
          )
        end

        tag_link_params[tag]['links'] = links.sort_by { |link| link['date'] }.reverse

        next unless tag_url
        site.pages << TagPage.new(site, site.source, tag_url, tag, posts)
      end

      File.write('/tmp/tag_link_boxes.json', tag_link_params.to_json)
      output_filepath = '../template.enogineer.com/_data/tag_link_boxes.json'
      if File.exists?(output_filepath)
        File.write(output_filepath, tag_link_params.to_json)
      end
    end
  end
end

class Jekyll::Post
  EXCERPT_ATTRIBUTES_FOR_LIQUID.push :tag_link_groups

  def tag_link_groups
    return data['tag_link_groups'] if data['tag_link_groups']
    existing_urls = []
    tag_link_groups = {}

    tags.each do |tag|
      link_group = site.data['tag_link_boxes'][tag]
      next if link_group.nil?

      links = link_group['links']
      next if links.nil?

      links = links.reject { |link| existing_urls.include?(link['url']) }
      next if links.empty?

      existing_urls.concat(links.map{ |link| link['url'] })
      link_group = link_group.merge('links' => links)
      tag_link_groups[tag] = link_group
    end

    data['tag_link_groups'] = tag_link_groups
  end
end
