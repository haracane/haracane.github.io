require "time"
require_relative "../generals/front_matter"
require_relative "./post"

NAMES = {
  "index" => "連載記事",
  "model-spec-custom-matchers" => "Rails4のActiveRecord向けRSpecカスタムマッチャ5選",
  "rails-capybara" => "Rails4＋RSpec＋Capybaraでよく使うマッチャ＆メソッド22個+α",
  "rails-restful" => "Rails4でRESTfulアプリケーションの7アクション＋αを作る",
}

module Domains
  module Category
    def self.all
      @@all ||= category_to_post_paths.keys
    end

    def self.names
      return @@names if defined?(@@names)
      @@names =
        all
          .map do |code|
            name = NAMES[code]
            throw "Not code for category: #{code}" if name.nil?
            [code, name]
          end
          .to_h
    end

    def self.category_to_post_paths
      return @@category_to_post_paths if defined?(@@category_to_post_paths)
      category_to_post_paths = {}
      Domains::Post.path_to_categories.each do |post_path, categorys|
        categorys.each do |category|
          category_to_post_paths[category] ||= []
          category_to_post_paths[category] << post_path
        end
      end
      @@category_to_post_paths = category_to_post_paths
    end
  end
end
