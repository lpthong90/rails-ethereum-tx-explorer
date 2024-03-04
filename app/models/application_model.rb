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

  def attributes=(hash)
    hash.each do |key, value|
      new_key = camel_to_snake(key)
      send("#{new_key}=", value)
    end
  end

  def self.from_json(data)
    return unless data
    self.new(**data)
  end
end
