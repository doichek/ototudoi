class Topic < ApplicationRecord
  belongs_to :user
  
  validates :title, presence: true, length: { maximum: 255 }
  
  has_many :microposts, dependent: :destroy
  
  has_many :favorites
  has_many :likes, through: :favorites, source: :user
  
end
