module Types
  class HexInteger < ActiveModel::Type::Integer
    def type
      :hex_integer
    end

    def deserialize(value)
      return if value.blank?
      value.to_i(16)
    end

    def serialize(value)
      value = ensure_in_range(super)
      "0x#{value.to_s(16)}"
    end

    private

      def cast_value(value)
        return value if value.class == Integer
        value.to_i(16) rescue nil
      end
  end
end