class Nat < ApplicationRecord
  validates :int_ip, format: { with: /\A^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\z/,
    message: "Must IP address" }
  validates :int_port, :ext_port, numericality: { :greater_than => 0, :less_than => 65535 }
  validates :ext_port, uniqueness: true
  validates :name, :int_port, :int_ip, presence: true
end
