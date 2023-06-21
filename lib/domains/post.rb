require_relative "../generals/file"
require_relative "../generals/front_matter"

module Domains
  module Post
    def self.all_paths
      @@all_paths ||= Generals::File.list_paths("_posts")
    end

    def self.all
      @@all ||= all_paths.map { |post_path| parse(post_path) }
    end

    def self.parse(path)
      post = Generals::FrontMatter.parse(path)
      post["path"] = path
      post["filebody"] = ::File.basename(path, ".md")
      post["tags"] = (post["tags"] || "").split(/\s+/).map(&:strip)

      content = post["content"]
      content.split("\n")
      tag_lines = []
      content_lines = []

      content_lines = content.split("\n")

      if content_lines[0] =~ %r{/tags/}
        tag_lines << content_lines.shift
        content_lines.shift if content_lines[0] == ""
      end

      post["tag_lines"] = tag_lines
      post["content_lines"] = content_lines

      post
    end

    def self.path_to_tags
      @@post_to_tags ||= all.map { |post| [post["path"], post["tags"]] }.to_a
    end
  end
end
