Dir['./app/types/*.rb'].each { require _1 }

ActiveModel::Type.register(:hex_integer, Types::HexInteger)
