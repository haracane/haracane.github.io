require_relative "./yaml"

module Generals
  module FrontMatter
    def self.parse(filepath)
      data = ::File.read(filepath)
      lines = data.lines
      front_matter_lines = []

      while true
        line = lines.shift
        if line.strip == "---"
          while true
            line = lines.shift
            break if line.nil? || line.strip == "---"
            front_matter_lines << line
          end
          break
        end

        break if line.nil?
      end

      front_matter = front_matter_lines.join
      meta = Generals::YAML.load(front_matter)
      front_matter_keys = meta.keys.map(&:to_s)
      parsed = meta
      parsed["front_matter"] = front_matter
      parsed["front_matter_keys"] = front_matter_keys
      parsed["content"] = lines.join
      parsed
    end
  end
end
