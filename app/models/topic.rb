class Topic < ApplicationRecord
  belongs_to :user
  
  validates :title, presence: true, length: { maximum: 255 }
  
  has_many :microposts
  
  has_many :favorites
  has_many :likes, through: :favorites, source: :user
  
  # def self.sort(selection)
  #   case selection
  #   when 'new'
  #     return all.order(id: :DESC)
  #   when 'old'
  #     return all.order(id: :ASC)
  #   end
  # end
end
