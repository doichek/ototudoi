class Micropost < ApplicationRecord
  belongs_to :user
  belongs_to :topic
  
  validates :content, presence: true, length: { maximum: 255 }
end
