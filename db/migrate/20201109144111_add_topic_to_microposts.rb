class AddTopicToMicroposts < ActiveRecord::Migration[5.2]
  def change
    add_reference :microposts, :topic, foreign_key: true
  end
end
