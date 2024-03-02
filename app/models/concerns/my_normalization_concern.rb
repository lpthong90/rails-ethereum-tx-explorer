module MyNormalizationConcern
  extend ActiveSupport::Concern

  class NormalizedType < DelegateClass(ActiveModel::Type::Value)
    private attr_reader :normalizer, :allow_nil
  
    def initialize(subtype, normalizer, allow_nil: true)
      @normalizer = normalizer
      @allow_nil = allow_nil
      super(subtype)
    end
  
    def cast(value)
      super(value).then do |casted|
        next if casted.nil? && allow_nil
  
        normalizer.call(casted)
      end
    end
  
    def serialize(value)
      return super(value) if value.nil? && allow_nil
  
      super(normalizer.call(value))
    end
  
    def deserialize(value)
      super(value).then do |casted|
        next if casted.nil? && allow_nil
  
        normalizer.call(casted)
      end
    end
  end

  module ClassMethods
    def normalize(attr_name, proc, **options)
      puts "=> normalize I'm here"
      attribute(attr_name) do
        NormalizedType.new(_1, proc, **options)
      end
    end
  end
end