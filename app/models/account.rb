# frozen_string_literal: true

class Account < ApplicationRecord
  belongs_to :user

  scope :user_accounts, ->(user_id) { where(user_id:) }
end
