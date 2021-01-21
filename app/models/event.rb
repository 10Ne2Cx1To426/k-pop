class Event < ApplicationRecord
  attr_accessor :tag_name

  # イベントのトップ画像
  has_one_attached :image
  # イベントとタグのassociation
  has_many :tagmaps, dependent: :destroy
  has_many :tags, through: :tagmaps
  # ユーザーとのアソシエーション
  belongs_to :user
  # joinとのアソシエーション
  has_many :joins
  # イベントに対するコメントのバリデーション 
  has_many :comments, dependent: :destroy
  #ActiveHasyの設定(都道府県)
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :prefecture
  # フォームのバリデーション
  with_options presence: true do
    validates :name
    validates :text
    validates :date
    validates :start_time
    validates :finish_time

    validates :postal_code, format: { with: /\A\d{3}[-]\d{4}\z/, message: "is invalid. Include hyphen(-)"}
    validates :city, format: { with: /\A[ぁ-んァ-ン一-龥]/, message: "is invalid. Input full-width characters."}
    validates :house_number

    validates :member

    validates :tag_name
  end

  # 都道府県
  validates :prefecture_id, numericality: { other_than: 0, message: "can't be blank" }

  # タグ保存用のメソッド
  def save_events(tags)
    current_tags = self.tags.pluck(:tag_name) unless self.tags.nil?
    old_tags = current_tags - tags
    new_tags = tags - current_tags
  
    # Destroy
    old_tags.each do |old_name|
      self.tags.delete Tag.find_by(tag_name:old_name)
    end

    # Create
    new_tags.each do |new_name|
      blog_tag = Tag.find_or_create_by(tag_name:new_name)
      self.tags << blog_tag
    end
  end
  # イベント参加人数を数えるためのメソッド
  def joined_by?(user)
    joins.where(user_id: user.id).exists?
  end
end
