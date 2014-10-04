class CategoryPage < Jekyll::Page
  def initialize(site, base, dir, category, posts)
    @site = site
    @base = base
    @dir = dir
    @name = "index.html"

    self.process(@name)
    self.read_yaml(File.join(base, '_layouts'), 'category.html')
    category_name = site.data["category_names"][category]
    self.data['title'] = "「#{category_name}（全#{posts.size}回）」のバックナンバー"
    self.data['description'] = "「#{category_name}（全#{posts.size}回）」のバックナンバー記事の一覧です"
    self.data['category'] = category
    self.data['posts'] = posts
  end
end

module CategoryPages
  class Generator < Jekyll::Generator
    safe true

    def generate(site)
      return unless site.layouts.key? "category"

      site.categories.each_pair do |category, posts|
        category_url = "/categories/#{category}/"
        site.pages << CategoryPage.new(site, site.source, category_url, category, posts)
      end
    end
  end
end
