class AddTagToTopics < ActiveRecord::Migration[5.2]
  def change
    add_column :topics, :tag, :integer
  end
end
