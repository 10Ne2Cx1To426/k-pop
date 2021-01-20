class Join < ApplicationRecord
  belongs_to :event
  has_many :users
end
