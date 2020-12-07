class AddFlagToTopics < ActiveRecord::Migration[5.2]
  def change
    add_column :topics, :flag, :integer
  end
end
