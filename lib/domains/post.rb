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

      post["categories"] = parse_list(post["categories"])
      post["tags"] = parse_list(post["tags"])

      content_lines = post["content"].lines

      key = "content"
      lines = []
      while line = content_lines.shift
        if line =~ /^<!-- ((content)|(tag_links)) -->$/
          next_key = $1
          post[key] = lines.join
          lines = []
          key = next_key
        else
          lines << line
        end
      end

      post[key] = lines.join

      ["tag_links"].each { |key| post[key] = post[key].strip if post[key] }

      post
    end

    def self.parse_list(list)
      list = list.split(/\s+/).map(&:strip) if list.is_a?(String)
      list = [] if list.nil?
      list
    end

    def self.path_to_categories
      @@path_to_categories ||=
        all.map { |post| [post["path"], post["categories"]] }.to_a
    end

    def self.path_to_tags
      @@post_to_tags ||= all.map { |post| [post["path"], post["tags"]] }.to_a
    end

    def self.store(post)
      front_matter =
        post["front_matter_keys"].map { |key| [key, post[key]] }.to_h

      sections = [::YAML.dump(front_matter), "---\n"]

      if post["tag_links"]
        sections << "<!-- tag_links -->\n"
        sections << post["tag_links"]
        sections << "\n\n"
      end

      sections << "<!-- content -->\n"
      sections << post["content"]

      ::File.write(post["path"], sections.join)
    end

    def self.to_link_with_date(post)
      title = post["title"]
      date = Time.parse(post["date"]).strftime("%Y/%m/%d")
      "[#{title}(#{date})]({% post_url #{post["filebody"]} %})"
    end
  end
end
