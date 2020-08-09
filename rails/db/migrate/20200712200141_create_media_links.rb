class CreateMediaLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :media_links do |t|
      t.string :url 
      t.references :story
      t.timestamps
    end
  end
  # def update_url(url)
  #   url["watch?v="]="embed/"
  #   # "watch?v=" ==> "embed/"
  # end
end
