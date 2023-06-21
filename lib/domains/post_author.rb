require_relative "./config"
require_relative "./post"

module Domains
  module PostAuthor
    def self.build(post)
      author = Domains::Config.all["author"]
      return if author.nil?
      return if post["author"]

      ::File.write(
        post["path"],
        [
          "---",
          "author: #{author}",
          post["front_matter"],
          "---",
          *post["content"],
        ].join("\n")
      )
    end

    def self.build_all
      Domains::Post.all.each { |post| build(post) }
    end
  end
end
