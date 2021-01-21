class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable
  validates :nickname, presence: { message: 'ニックネームを入力してください' }

  with_options presence: true, format: { with: /\A[ぁ-んァ-ヶ一-龥々]+\z/, message: '全角文字を使用してください' } do
    validates :firstname
    validates :lastname
  end

  validates :birthday, presence: { message: '生年月日を入力してください'}

  with_options presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: '@を含めて入力してください' }, uniqueness: { case_sensitive: false } do
    validates :email
  end
  
  PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?[\d])[a-z\d]+\z/i.freeze

  with_options presence: true, format: { with: PASSWORD_REGEX, message:'には英字と数字の両方を含めて設定してください' }, length: { minimum: 6 }, confirmation: true, on: :create do
    validates :password
  end

  validates :password_confirmation, presence: true, on: :create
  validates :image, presence: true

  # イベントのアソシエーション
  has_many :events
  # joinとのアソシエーション
  has_many :joins
  # コミュニティのアソシエーション
  has_many :group_users, dependent: :destroy
  has_many :groups
  # messageとのassociation
  has_many :messages
  # favとのassociation
  has_many :favorites
  # イベントに対するコメントのバリデーション
  has_many :comments

  # 自分がフォローしているユーザーとの関連
  has_many :active_relationships, class_name: "Relationship", foreign_key: :following_id
  has_many :followings, through: :active_relationships, source: :follower

  # 自分がフォローされるユーザーとの関連
  has_many :passive_relationships, class_name: "Relationship", foreign_key: :follower_id
  has_many :followers, through: :passive_relationships, source: :following

  def followed_by?(user)
    passive_relationships.find_by(following_id: user.id).present?
  end
  # マッチングの実装
  def matchers
    # User.where(id: passive_relationships.select(:follower_id))
     # .where(id: active_relationships.select(:following_id))
    User.where(id: passive_relationships.select(:following_id))
     .where(id: active_relationships.select(:follower_id))
  end
  # DMの実装
  has_many :dms, dependent: :destroy
  has_many :entries, dependent: :destroy
  # プロフィール画像の実装
  has_one_attached :image
end
