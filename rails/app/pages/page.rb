class Page
  def meta
    ret = @meta.dup
    ret[:total] = total
    ret[:next_offset] = next_offset
    ret[:limit] = limit
    ret[:offset] = offset

    ret
  end

  def next_page_meta
    ret ||= @meta.dup
    ret[:limit] = limit
    ret[:offset] = next_offset
    ret
  end

  def has_next_page?
    next_offset.present?
  end

  def relation
    raise NotImplementedError
  end

  def data
    relation.limit(limit).offset(offset)
  end

  # Returns the total number of records for relation, not just the
  # number in our limit and offset.
  def total
    @total ||= relation.count
  end

  # Returns the next offset. Useful for clients doing pagination.
  def next_offset
    next_offset = offset + limit
    return nil if next_offset >= total

    next_offset
  end

  def limit
    @meta[:limit].to_i
  end

  def offset
    @meta[:offset].to_i
  end
end
