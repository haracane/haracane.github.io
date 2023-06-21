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
      parsed = Generals::YAML.load(front_matter)
      parsed["front_matter"] = front_matter
      parsed["content"] = lines.join
      parsed
    end
  end
end
