class User < ApplicationRecord
  validates :address, format: { with: /\A^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\z/,
    message: "Must IP address" }
  validates :date_of_disconnect, :name, presence: true
  validates :address, :name, uniqueness: true
end
