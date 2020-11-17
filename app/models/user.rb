class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  #カラムの名前をmount_uploaderに指定
  mount_uploader :image, ImageUploader
  
  has_many :microposts
  has_many :topics
  
  #お気に入り関連
  has_many :favorites
  has_many :likes, through: :favorites, source: :topic
  def favorite(topic)
      self.favorites.create(topic_id: topic.id)
  end
  
  def unfavorite(topic)
      favorite = self.favorites.find_by(topic_id: topic.id)
      favorite.destroy if favorite
  end
  
  def likes?(topic)
      self.likes.include?(topic)
  end
  
  #リレーションシップ関連
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user

  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end
  
  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  
  
end