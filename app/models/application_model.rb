class ApplicationModel
  include ActiveModel::API
  include ActiveModel::Validations
  include ActiveModel::Serializers::JSON
  include ActiveModel::Attributes 
  include ActiveModel::Validations

  include Turbo::Broadcastable

  def attributes
    instance_values["attributes"]
  end

  def assign_attributes(hash)
    hash.each do |key, value|
      new_key = camel_to_snake(key)
      send("#{new_key}=", value)
    end
  end

  private
    def camel_to_snake(string)
      string.to_s.gsub(/([A-Z])/, '_\1').downcase.sub(/^_/, '')
    end
end
