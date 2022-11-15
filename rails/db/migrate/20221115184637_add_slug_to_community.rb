class AddSlugToCommunity < ActiveRecord::Migration[6.1]
  def up
    add_column :communities, :slug, :string

    Community.find_each do |community|
      slug = community.name.downcase.strip.gsub(" ", "_")
      if Community.exists?(slug: slug)
        index = 0
        loop do
          index+=1
          slug = [slug, index].join("_")
          break unless Community.exists?(slug: slug)
        end
      end
      community.update(slug: slug)
    end

    add_index :communities, :slug
  end

  def down
    remove_column :communities, :slug
  end
end
