class User < ApplicationRecord
       # Associations
       has_many :reservations, dependent: :destroy
       has_one_attached :avatar
     
       # Devise modules
       devise :database_authenticatable, :registerable,
              :recoverable, :rememberable, :validatable
     
       # Temporary accessor for current_password
       attr_accessor :current_password
     
       # Validations
       validates :name, presence: true
       validates :email, presence: true, uniqueness: true
       validates :bio, length: { maximum: 300 }, allow_blank: true
     
       # Custom validation for current password
       validate :validate_current_password, if: :current_password_required?
     
       # Custom update method to bypass password validation
       def update_without_password(params)
         params.delete(:current_password)
         params.delete(:password)
         params.delete(:password_confirmation)
         update(params)
       end
     
       private
     
       # Check if current password validation is required
       def current_password_required?
         persisted? && current_password.present? && password.present?
       end
     
       # Validate the current password
       def validate_current_password
         unless valid_password?(current_password)
           errors.add(:current_password, "が正しくありません")
         end
       end
     end