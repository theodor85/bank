# frozen_string_literal: true

class Transfer < ApplicationRecord
  enum operation_type: %i[income
                          transfer_by_account
                          transfer_by_card
                          transfer_by_phone
                          transfer_to_yourself
                          pay]

  belongs_to :source_account, class_name: 'Account', optional: true
  belongs_to :dest_account, class_name: 'Account', optional: true

  scope :account_transfers, lambda { |account_id|
    where('source_account_id = ? OR dest_account_id = ?', account_id, account_id)
  }
end
