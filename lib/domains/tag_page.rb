require "time"
require_relative "./post"
require_relative "./tag"

module Domains
  module TagPage
    def self.build(name)
      code = Domains::Tag.codes[name]
      tag_path = ::File.join("tags", "#{code}.md")
      post_paths = Domains::Tag.tag_to_post_paths[name]

      post_items =
        post_paths.reverse.map do |post_path|
          post = Domains::Post.parse(post_path)
          "- #{Domains::Post.to_link_with_date(post)}"
        end

      File.write(tag_path, <<~EOS)
        ---
        layout: default
        title: #{name}
        ---
        # #{name}の記事一覧

        #{post_items.join("\n")}
      EOS

      puts "Generated #{tag_path}"
    end

    def self.build_all
      system("rm tags/*.md")
      Domains::Tag.all.each { |name| build(name) }
    end
  end
end
