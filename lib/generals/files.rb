module Generals
  module Files
    def self.list_paths(dir)
      Dir.glob("#{dir}/*").select { |file| File.file?(file) }
    end
  end
end
