require_relative "./post"
require_relative "./tag"

module Domains
  module TagLink
    def self.build(post)
      tags = post["tags"]
      return if tags.length == 0
      post["tag_lines"] = [
        tags
          .map { |tag| "[#{tag}](/tags/#{Domains::Tag.codes[tag]}/)" }
          .join(" / ")
      ]

      ::File.write(
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

    def self.build_all
      Domains::Post.all.each { |post| build(post) }
    end
  end
end
