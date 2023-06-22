require "time"
require_relative "./post"
require_relative "./category"

CATEGORIES_DIR = "_includes/categories"

module Domains
  module CategoryPage
    def self.build(code)
      name = Domains::Category.names[code]
      category_path = ::File.join(CATEGORIES_DIR, "#{code}.md")
      post_paths = Domains::Category.category_to_post_paths[code]

      post_items =
        post_paths.map do |post_path|
          post = Domains::Post.parse(post_path)
          "- #{Domains::Post.to_link_with_date(post)}"
        end

      File.write(category_path, <<~EOS)
        #{post_items.join("\n")}
      EOS

      puts "Generated #{category_path}"
    end

    def self.build_all
      system("rm #{CATEGORIES_DIR}/*.md")
      Domains::Category.all.each { |name| build(name) }
    end
  end
end
