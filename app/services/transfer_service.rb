# frozen_string_literal: true

class TransferService
  attr_reader :error

  def initialize(transfer_model, account)
    @transfer_model = transfer_model
    @account = account
    @error = nil
  end

  def new_transfer(type)
    return unless check_type_and_set_error(type)

    instantiate_new_transfer(type)
  end

  private

  def check_type_and_set_error(type)
    unless check_type(type)
      @error = 'Wrong operation type'
      return false
    end

    true
  end

  def check_type(type)
    %i[income
       transfer_by_account
       transfer_by_card
       transfer_by_phone
       transfer_to_yourself
       pay].include?(type)
  end

  def instantiate_new_transfer(type)
    case type
    in :income
      @transfer_model.new(operation_type: type,
                          dest_account_id: @account.id,
                          comment: 'Replenishing account')
    in :pay
      if check_card
        return @transfer_model.new(operation_type: type,
                                   source_account_id: @account.id,
                                   comment: 'Pay for purchases')
      end
      @error = 'You have no card yet'
    else
      @transfer_model.new(operation_type: type,
                          source_account_id: @account.id,
                          comment: 'Transfer')
    end
  end

  def check_card
    !@account.card.nil?
  end
end
