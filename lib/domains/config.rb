require_relative "../generals/yaml"

module Domains
  module Config
    def self.all
      @@all ||= Generals::YAML.load_file("_config.yml")
    end
  end
end
