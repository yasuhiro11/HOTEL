class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :check_in, :check_out, :number_of_guests, presence: true
  validates :number_of_guests, numericality: { greater_than_or_equal_to: 1 }
  validate :check_in_must_be_future_or_today
  validate :check_out_after_check_in

  # フォーマット用メソッド
  def formatted_check_in
    check_in.strftime('%Y/%m/%d') if check_in
  end
  
  def formatted_confirmed_at
    confirmed_at.strftime('%Y/%m/%d %H:%M') if confirmed_at
  end

  # 料金計算
  def total_price
    days = (check_out - check_in).to_i
    days * number_of_guests * room.price
  end

  private

  # カスタムバリデーション
  def check_in_must_be_future_or_today
    if check_in.present? && check_in < Date.today
      errors.add(:check_in, 'は本日以降の日付を選択してください。')
    end
  end

  def check_out_after_check_in
    if check_out.present? && check_in.present? && check_out <= check_in
      errors.add(:check_out, 'はチェックイン日より後の日付を選択してください。')
    end
  end
end
