class Room < ApplicationRecord
    belongs_to :user
  
    has_one_attached :image
  
    validates :name, :description, :price, :address, presence: true
    validates :price, numericality: { greater_than_or_equal_to: 1 }
  end
