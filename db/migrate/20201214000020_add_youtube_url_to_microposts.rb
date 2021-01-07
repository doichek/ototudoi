class AddYoutubeUrlToMicroposts < ActiveRecord::Migration[5.2]
  def change
    add_column :microposts, :youtube_url, :string
  end
end
