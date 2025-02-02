class Room < ApplicationRecord
  belongs_to :user
  belongs_to :facility

  has_one_attached :image
  has_many :reservations, dependent: :destroy

  validates :name, :description, :price, :address, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 1 }

  after_initialize :attach_default_image, if: :new_record?

  private

  def attach_default_image
    return if image.attached?

    image.attach(
      io: File.open(Rails.root.join('app/assets/images/default_hotel_image.png')),
      filename: 'default_hotel_image.png',
      content_type: 'image/png'
    )
  end
end