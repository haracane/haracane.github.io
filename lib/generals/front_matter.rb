require "yaml"

module Generals
  module FrontMatter
    def self.parse(filepath)
      data = File.read(filepath)
      blocks = data.split(/^(---\s*$\n?)/m)
      front_matter = blocks[2].strip
      content = blocks[4]
      parsed = YAML.safe_load(front_matter, permitted_classes: [Time])
      parsed["front_matter"] = front_matter
      parsed["content"] = content || ""
      parsed
    end
  end
end