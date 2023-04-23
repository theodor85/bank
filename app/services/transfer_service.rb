# frozen_string_literal: true

require_relative './transfer_creator'

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

  def create_transfer(params)
    case params[:operation_type].to_sym
    in :income
      @transfer, @error = IncomeCreator.new.call(params, @transfer_model, @account)

    in :transfer_by_account
      @transfer, @error = ByAccountCreator.new.call(params, @transfer_model, @account)

    in :transfer_by_card
      @transfer, @error = ByCardCreator.new.call(params, @transfer_model, @account)

    in :transfer_by_phone
      @transfer, @error = ByPhoneCreator.new.call(params, @transfer_model, @account)

    in :transfer_to_yourself
      @transfer, @error = ToYourselfCreator.new.call(params, @transfer_model, @account)

    in :pay
      @transfer, @error = PayCreator.new.call(params, @transfer_model, @account)
    end

    if @transfer&.persisted?
      true
    else
      false
    end
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
