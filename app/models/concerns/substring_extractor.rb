module SubstringExtractor
  extend ActiveSupport::Concern

  included do
    def self.extract_from_substring(original_string, substring)
      index = original_string.index(substring)
      index ? original_string[index..-1] : nil
    end
  end
end
