module NormalizationConcern
  extend ActiveSupport::Concern

  included do
    class_attribute :normalized_attributes, default: Set.new

    before_validation :normalize_changed_in_place_attributes
  end

  def normalize_attribute(name)
    self[name] = self[name]
  end

  module ClassMethods
    def normalizes(*names, with:, apply_to_nil: false)
      names.each do |name|
        attribute(name) do |cast_type|
          NormalizedValueType.new(cast_type: cast_type, normalizer: with, normalize_nil: apply_to_nil)
        end
      end

      self.normalized_attributes += names.map(&:to_sym)
    end

    def normalize(name, value)
      type_for_attribute(name).cast(value)
    end
  end

  private
    def normalize_changed_in_place_attributes
      self.class.normalized_attributes.each do |name|
        normalize_attribute(name) if attribute_changed_in_place?(name)
      end
    end

    class NormalizedValueType < DelegateClass(ActiveModel::Type::Value)
      include ActiveModel::Type::SerializeCastValue

      attr_reader :cast_type, :normalizer, :normalize_nil
      alias :normalize_nil? :normalize_nil

      def initialize(cast_type:, normalizer:, normalize_nil:)
        @cast_type = cast_type
        @normalizer = normalizer
        @normalize_nil = normalize_nil
        super(cast_type)
      end

      def cast(value)
        normalize(super(value))
      end

      def serialize(value)
        serialize_cast_value(cast(value))
      end

      def serialize_cast_value(value)
        ActiveModel::Type::SerializeCastValue.serialize(cast_type, value)
      end

      def ==(other)
        self.class == other.class &&
          normalize_nil? == other.normalize_nil? &&
          normalizer == other.normalizer &&
          cast_type == other.cast_type
      end
      alias eql? ==

      def hash
        [self.class, cast_type, normalizer, normalize_nil?].hash
      end

      def inspect
        Kernel.instance_method(:inspect).bind_call(self)
      end

      private
        def normalize(value)
          normalizer.call(value) unless value.nil? && !normalize_nil?
        end
    end
end
