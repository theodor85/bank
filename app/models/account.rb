# frozen_string_literal: true

class Account < ApplicationRecord
  belongs_to :user
  has_one :card, dependent: :destroy
  has_many :outgoing_transfer, class_name: 'Transfer'
  has_many :incoming_transfer, class_name: 'Transfer'

  scope :user_accounts, ->(user_id) { where(user_id:) }
end
