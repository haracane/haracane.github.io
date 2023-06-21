require "time"
require_relative "../generals/files"
require_relative "../generals/front_matter"
require_relative "./post"

CODES = {
  "アジャイル" => "agile",
  "AWS" => "aws",
  "キャッシュバック賃貸" => "cbchintai",
  "エクサウィザーズ" => "exawizards",
  "ハナスト" => "hanasuto",
  "フック" => "hook",
  "報告" => "information",
  "OAuth2.0" => "oauth2",
  "Repositoryパターン" => "repository-pattern",
  "スマホ" => "smartphone",
  "テスト" => "test"
}

module Domains
  module Tag
    def self.all
      @@all ||= tag_to_post_paths.keys
    end

    def self.build
      build_all_tag_pages
      build_tag_links
    end

    def self.build_all_tag_pages
      all.each { |name| build_tag_page(name) }
    end

    def self.build_tag_links
      Domains::Post.all.each do |post|
        tags = post["tags"]
        next if tags.length == 0
        post["tag_lines"] = [
          tags.map { |tag| "[#{tag}](/tags/#{codes[tag]}/)" }.join(" / ")
        ]

        File.write(
          post["path"],
          [
            "---",
            post["front_matter"],
            "---",
            *post["tag_lines"],
            "",
            *post["content_lines"],
            ""
          ].join("\n")
        )
      end
    end

    def self.build_tag_page(name)
      code = codes[name]
      tag_path = File.join("tags", "#{code}.md")
      post_paths = tag_to_post_paths[name]

      post_items =
        post_paths.reverse.map do |post_path|
          post = Domains::Post.parse(post_path)
          title = post["title"]
          date = Time.parse(post["date"]).strftime("%Y/%m/%d")
          "- [#{title}(#{date})]({% post_url #{post["filebody"]} %})"
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

    def self.codes
      return @@codes if defined?(@@codes)
      @@codes =
        all
          .map do |name|
            code = CODES[name]
            if code.nil?
              if name =~ /^[A-Za-z0-9]+$/
                code = name.downcase
              else
                throw "Not code for tag: #{name}"
              end
            end
            [name, code]
          end
          .to_h
    end

    def self.tag_to_post_paths
      return @@tag_to_post_paths if defined?(@@tag_to_post_paths)
      tag_to_post_paths = {}
      Domains::Post.path_to_tags.each do |post_path, tags|
        tags.each do |tag|
          tag_to_post_paths[tag] ||= []
          tag_to_post_paths[tag] << post_path
        end
      end
      @@tag_to_post_paths = tag_to_post_paths
    end
  end
end
