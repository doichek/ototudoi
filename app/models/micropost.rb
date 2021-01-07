class Micropost < ApplicationRecord
  belongs_to :user
  belongs_to :topic
  
  validates :content, length: { maximum: 255 }
  mount_uploader :image, ImageUploader

  # content,image,youtube_url全てnilだった場合だけ弾く
  validates :content_or_image_or_youtubeurl, presence: true

  private
    def content_or_image_or_youtubeurl
      content.presence or image.presence or youtube_url.presence
    end
end
