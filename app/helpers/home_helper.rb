module HomeHelper
  def left_hash(hash, size: 10)
    hash[..size]
  end

  def right_hash(hash, size: 10)
    hash[-size..]
  end

  def mid_hash(hash, from:, to:)
    hash[from..to]
  end
  
  def left_right_hash(hash, l_size: 10, r_size: 10)
    left_hash(hash, size: l_size) + '...' + right_hash(hash, size: r_size)
  end
end
