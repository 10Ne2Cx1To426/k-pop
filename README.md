# 概要
  K-POPのファン同士の交流を応援するコミュニティアプリです。
  URL : 
# DB設計図

| Column                  | Type    | Options                   |
|-------------------------|---------|---------------------------|
| nickname                | string  | null: false               |
| email                   | string  | null: false, unique: true |
| encrypted_password      | string  | null: false               |
| first_name              | string  | null: false               |
| last_name               | string  | null: false               |
| first_name_k            | string  | null: false               |
| last_name_k             | string  | null: false               |
| birth                   | date    | null: false               |