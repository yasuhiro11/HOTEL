class Booking < ApplicationRecord
  belongs_to :facility
  belongs_to :user

  # 日付のバリデーション
  validates :start_date, :end_date, presence: true
  validate :end_date_after_start_date

  # 人数のバリデーション（例: 1人以上、100人以下）
  validates :number_of_people, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 100 }

  private

  # 開始日より終了日が後であることを確認
  def end_date_after_start_date
    if start_date.present? && end_date.present? && end_date <= start_date
      errors.add(:end_date, "は開始日より後の日付を選択してください。")
    end
  end
end
