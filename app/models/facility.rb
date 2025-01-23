class Facility < ApplicationRecord
    has_one_attached :image
    has_many :bookings, dependent: :destroy
  end
