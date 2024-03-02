module StringConcern
  extend ActiveSupport::Concern

  def camel_to_snake(string)
    string.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
          .gsub(/([a-z\d])([A-Z])/, '\1_\2')
          .downcase
  end  
end