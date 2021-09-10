class AddTopicToStory < ActiveRecord::Migration[5.2]
    def change
        add_column :stories, :topic, :string
    end
end
