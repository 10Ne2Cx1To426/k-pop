# 概要
  K-POPのファン同士の交流を応援するコミュニティアプリです。
### 主な機能

* ユーザー登録機能
* イベント作成・参加機能
* オープンチャット作成・参加機能
* アカウントフォロー・フォロワー機能
* タグ付機能

# DB設計図

# User

| Column                  | Type    | Options                   |
|-------------------------|---------|---------------------------|
| nickname                | string  | null: false               |
| email                   | string  | null: false, unique: true |
| encrypted_password      | string  | null: false               |
| firstname               | string  | null: false               |
| lastname                | string  | null: false               |
| birthday                | date    | null: false               |
| text                    | text    | null: false               |

has_many :events
has_many :joins
has_many :group_users, dependent: :destroy
has_many :groups
has_many :messages
has_many :favorites
has_many :comments

has_many :active_relationships, class_name: "Relationship", foreign_key: :following_id
has_many :followings, through: :active_relationships, source: :follower

has_many :passive_relationships, class_name: "Relationship", foreign_key: :follower_id
has_many :followers, through: :passive_relationships, source: :following

# Event

| Column                  | Type       | Options                   |
|-------------------------|------------|---------------------------|
| name                    | string     | null: false               |
| text                    | text       | null: false               |
| date                    | date       | null: false               |
| start_time              | string     | null: false               |
| finish_time             | string     | null: false               |
| postal-code             | string     | null: false               |
| prefecture_id           | integer    | null: false               |
| city                    | string     | null: false               |
| house_number            | string     | null: false               |
| building                | string     |                           |
| member                  | integer    | null:false                |
| user                    | references | foreign_key: true         |

has_one_attached :image
has_many :tagmaps, dependent: :destroy
has_many :tags, through: :tagmaps
belongs_to :user
has_many :joins
has_many :comments, dependent: :destroy
belongs_to :prefecture

# Tag

| Column                  | Type    | Options                   |
|-------------------------|---------|---------------------------|
| tag_name                | siring  |                           |

has_many :tagmaps, dependent: :destroy
has_many :events, through: :tagmaps
has_many :group_tags, dependent: :destroy
has_many :groups, through: :group_tags

# Tagmap

| Column                  | Type    | Options                   |
|-------------------------|---------|---------------------------|
| event_id                | integer |                           |
| tag_id                  | integer |                           |

belongs_to :event
belongs_to :tag

# Join

| Column                  | Type       | Options                   |
|-------------------------|------------|---------------------------|
| user                    | references | foreign_key: true         |
| event                   | references | foreign_key: true         |

belongs_to :event
has_many :users

# Group

| Column                  | Type       | Options                   |
|-------------------------|------------|---------------------------|
| name                    | string     | null: false               |
| text                    | text       | null: false               |
| user                    | references | foreign_key: true         |

has_one_attached :image
has_many :group_users, dependent: :destroy
has_many :users, through: :group_users
has_many :messages
has_many :favorites
has_many :group_tags, dependent: :destroy
has_many :tags, through: :group_tags
validates :name, presence: true
validates :text, presence: true

# Group_user

| Column                  | Type       | Options                   |
|-------------------------|------------|---------------------------|
| user                    | references | foreign_key: true         |
| group                   | references | foreign_key: true         |

belongs_to :user
belongs_to :group

# Message

| Column                  | Type       | Options                   |
|-------------------------|------------|---------------------------|
| content                 | text       |                           |
| group                   | references | foreign_key: true         |
| user                    | references | foreign_key: true         |

belongs_to :user
belongs_to :group

has_one_attached :image

# GroupTag

| Column                  | Type    | Options                   |
|-------------------------|---------|---------------------------|
| group_id                | integer |                           |
| tag_id                  | integer |                           |

belongs_to :group
belongs_to :tag

# Favorite

| Column                  | Type       | Options                   |
|-------------------------|------------|---------------------------|
| user                    | references | foreign_key: true         |
| group                   | references | foreign_key: true         |

belongs_to :user
belongs_to :group

# Relationship

| Column                  | Type    | Options                   |
|-------------------------|---------|---------------------------|
| following_id            | integer |                           |
| follower_id             | integer |                           |

belongs_to :following, class_name: "User"
belongs_to :follower, class_name: "User"

# Room

| Column                  | Type       | Options                   |
|-------------------------|------------|---------------------------|
| user                    | references | foreign_key: true         |

has_many :dms, dependent: :destroy
has_many :entries, dependent: :destroy

# Entry

| Column                  | Type       | Options                   |
|-------------------------|------------|---------------------------|
| user                    | references | foreign_key: true         |
| room                    | references | foreign_key: true         |

belongs_to :user
belongs_to :room

# DM

| Column                  | Type       | Options                   |
|-------------------------|------------|---------------------------|
| message                 | text       | null: false               |
| user                    | references | foreign_key: true         |
| room                    | references | foreign_key: true         |

belongs_to :user
belongs_to :room

has_one_attached :image

# Comment

| Column                  | Type       | Options                   |
|-------------------------|------------|---------------------------|
| text                    | text       |                           |
| user                    | references | foreign_key: true         |
| event                   | references | foreign_key: true         |

belongs_to :user
belongs_to :event