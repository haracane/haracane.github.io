require_relative "./post"
require_relative "./tag"

module Domains
  module TagLink
    def self.build(post)
      tags = post["tags"]
      return if tags.length == 0
      post["tag_links"] = tags
        .map { |tag| "[#{tag}](/tags/#{Domains::Tag.codes[tag]}/)" }
        .join(" / ") + "\n"

      Domains::Post.store(post)
    end

    def self.build_all
      Domains::Post.all.each { |post| build(post) }
    end
  end
end
