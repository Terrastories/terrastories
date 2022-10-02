class SearchPage < Page
  def initialize(community, meta = {})
    @community = community
    @meta = meta

    @meta[:limit] ||= 10
    @meta[:offset] ||= 0
  end

  def data
    relation.drop(offset).take(limit)
  end

  def relation
    return [] if @meta[:search].blank?
    # Union Match:
    # - id: the unique identifier of the matched record
    # - term_match: the term that is searched against
    # - table_name: hard-coded table name for display conditionals
    # - created_at: for predictable ordering
    #
    #
    # NOTE: Use UNION ALL to avoid unnecessary db comparison to filter for
    # duplicates on UNION. Duplicates are preferrable when they occur.
    raw_sql = <<~SQL
    SELECT union_match.* FROM (
      SELECT id, name as term_match, 'speaker' as table_name, created_at
        FROM speakers
        WHERE community_id = #{@community.id}
          AND name ILIKE '%#{@meta[:search]}%'
      UNION ALL
      SELECT id, name as term_match, 'place' as table_name, created_at
        FROM places
        WHERE community_id = #{@community.id}
          AND name ILIKE '%#{@meta[:search]}%'
      UNION ALL
      SELECT id, title as term_match, 'story' as table_name, created_at
        FROM stories
        WHERE community_id = #{@community.id}
          AND title ILIKE '%#{@meta[:search]}%'
      UNION ALL
      SELECT id, stories.desc as term_match, 'story' as table_name, created_at
        FROM stories
        WHERE community_id = #{@community.id}
          AND stories.desc ILIKE '%#{@meta[:search]}%'
    ) union_match
    ORDER BY created_at
    SQL
    ActiveRecord::Base.connection.exec_query(raw_sql)
  end

  def total
    @total ||= relation.count
  end
end