class Tag < ApplicationRecord
  # イベントとのアソシエーション
  has_many :tagmaps, dependent: :destroy
  has_many :events, through: :tagmaps
  # コミュニティとのアソシエーション
  has_many :group_tags, dependent: :destroy
  has_many :groups, through: :group_tags
end
