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

      tags = post["tags"] || []
      tags = tags.split(/\s+/).map(&:strip) if tags.is_a?(String)
      post["tags"] = tags

      content_lines = post["content"].lines

      post["tag_links"] = content_lines.shift if content_lines[0] =~ %r{/tags/}

      content_lines.shift while content_lines[0] == "\n"

      post["content"] = content_lines.join

      post
    end

    def self.path_to_tags
      @@post_to_tags ||= all.map { |post| [post["path"], post["tags"]] }.to_a
    end

    def self.store(post)
      front_matter =
        post["front_matter_keys"].map { |key| [key, post[key]] }.to_h

      ::File.write(
        post["path"],
        [
          ::YAML.dump(front_matter),
          "---\n",
          post["tag_links"],
          "\n",
          post["content"],
        ].join,
      )
    end
  end
end
