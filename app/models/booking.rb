class Booking < ApplicationRecord
  belongs_to :facility
  belongs_to :user, optional: true # ユーザーを必須にする場合は `optional: true` を削除
  validates :start_date, :end_date, presence: true
end
