require "time"
require_relative "../generals/front_matter"
require_relative "./post"

CODES = {
  "アジャイル" => "agile",
  "AWS" => "aws",
  "キャッシュバック賃貸" => "cbchintai",
  "エクサウィザーズ" => "exawizards",
  "ハナスト" => "hanasuto",
  "フック" => "hook",
  "報告" => "information",
  "OAuth2.0" => "oauth2",
  "Repositoryパターン" => "repository-pattern",
  "スマホ" => "smartphone",
  "テスト" => "test"
}

module Domains
  module Tag
    def self.all
      @@all ||= tag_to_post_paths.keys
    end

    def self.codes
      return @@codes if defined?(@@codes)
      @@codes =
        all
          .map do |name|
            code = CODES[name]
            if code.nil?
              if name =~ /^[A-Za-z0-9]+$/
                code = name.downcase
              else
                throw "Not code for tag: #{name}"
              end
            end
            [name, code]
          end
          .to_h
    end

    def self.tag_to_post_paths
      return @@tag_to_post_paths if defined?(@@tag_to_post_paths)
      tag_to_post_paths = {}
      Domains::Post.path_to_tags.each do |post_path, tags|
        tags.each do |tag|
          tag_to_post_paths[tag] ||= []
          tag_to_post_paths[tag] << post_path
        end
      end
      @@tag_to_post_paths = tag_to_post_paths
    end
  end
end
