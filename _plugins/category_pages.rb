class CategoryPage < Jekyll::Page
  def initialize(site, base, dir, category, category_params, posts)
    @site = site
    @base = base
    @dir = dir
    @name = ""

    self.process(@name)
    self.read_yaml(File.join(base, '_layouts'), 'category.html')

    category_title = category_params["title"]
    if category_params["finished"]
      article_type = "バックナンバー記事（全#{posts.size}回）"
    else
      article_type = "連載記事（計#{posts.size}回）"
    end
    self.data['title'] = "「#{category_title}」の#{article_type}"
    self.data['description'] = category_params["description"]
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

        next if site.data["category_params"].nil?
        category_params = site.data["category_params"][category]
        next if category_params.nil?

        site.pages << CategoryPage.new(site, site.source, category_url, category, category_params, posts)
      end
    end
  end
end
