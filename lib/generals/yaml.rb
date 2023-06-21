require "yaml"

module Generals
  module YAML
    def self.load(str)
      ::YAML.safe_load(str, permitted_classes: [Time])
    end

    def self.load_file(filepath)
      load(::File.read(filepath))
    end
  end
end
