class ApplicationModel
  include ActiveModel::API
  include ActiveModel::Validations
  include ActiveModel::Serializers::JSON
  include ActiveModel::Attributes 
  include ActiveModel::Validations

  include Turbo::Broadcastable

  # include NormalizationConcern
  include MyNormalizationConcern
  include StringConcern

  def attributes
    instance_values
  end

  def attributes=(hash)
    hash.each do |key, value|
      new_key = camel_to_snake(key)
      send("#{new_key}=", value)
    end
  end
end
