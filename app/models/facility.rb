class Facility < ApplicationRecord
  has_one_attached :image
  has_many :bookings, dependent: :destroy
  has_many :rooms, dependent: :destroy

  # バリデーション
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :location, presence: true
  validates :name, presence: true

  # 施設作成時にデフォルトの部屋を作成
  after_create :create_default_room

  private

  def create_default_room
    # 適切なユーザーを取得
    user = User.first
    if user.nil?
      Rails.logger.error("No user found to assign default room for facility #{id}")
      raise "User not found for creating default room. Please create a user."
    end

    # デフォルト部屋を作成
    room = Room.new(
      name: name,
      facility_id: id,
      price: price || 100,
      address: location || "Default Address",
      user: user,
      description: description.presence || "Default description"
    )

    # デフォルト画像を添付
    default_image_path = Rails.root.join('app/assets/images/default_hotel_image.png')
    if File.exist?(default_image_path)
      room.image.attach(
        io: File.open(default_image_path),
        filename: 'default_hotel_image.png',
        content_type: 'image/png'
      )
    else
      Rails.logger.error("Default image not found at #{default_image_path}")
      raise "Default image file is missing. Please add 'default_hotel_image.png' to app/assets/images."
    end

    room.save!
  rescue StandardError => e
    Rails.logger.error("Failed to create default room for facility #{id}: #{e.message}")
    raise e
  end
end