class Group < ApplicationRecord
  # グループのトップ画像
  has_one_attached :image
  # ユーザーのassociation
  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users
  # messageのassociation
  has_many :messages
  # favのassociation
  has_many :favorites
  # tagのassociation
  has_many :group_tags, dependent: :destroy
  has_many :tags, through: :group_tags
  # groupのバリデーション
  validates :name, presence: true
  validates :text, presence: true
  # favの機能
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
  # タグ保存用のメソッド
  def save_groups(tags)
    current_tags = self.tags.pluck(:tag_name) unless self.tags.nil?
    old_tags = current_tags - tags
    new_tags = tags - current_tags
  
    # Destroy
    old_tags.each do |old_name|
      self.tags.delete Tag.find_by(tag_name:old_name)
    end

    # Create
    new_tags.each do |new_name|
      group_tag = Tag.find_or_create_by(tag_name:new_name)
      self.tags << group_tag
    end
  end
end
