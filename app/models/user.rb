class User < ApplicationRecord
  belongs_to :company

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, uniqueness: true, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true
  validates :password_confirmation, presence: true
  validates :api_key, presence: true, uniqueness: true

  before_save { email.try(:downcase) }
  has_secure_password
end
