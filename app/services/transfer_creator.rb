# frozen_string_literal: true

class AbstractTransferCreator
  def call(params, transfer_model, current_account)
    @params = params
    @current_account = current_account
    @transfer_model = transfer_model
    @transfer = nil
    @error = nil

    set_source_account
    set_destination_account
    validate_operation
    instantiate_transfer
    commit_transaction

    [@transfer, @error]
  rescue StandardError => e
    @error = e.message

    [@transfer, @error]
  end

  def set_source_account
    raise NotImplementedError
  end

  def set_destination_account
    raise NotImplementedError
  end

  def validate_operation
    raise NotImplementedError
  end

  def instantiate_transfer
    raise NotImplementedError
  end

  def commit_transaction
    raise NotImplementedError
  end
end

class IncomeCreator < AbstractTransferCreator
  def set_source_account
    @source_account = nil
  end

  def set_destination_account
    @destination_account = @current_account
  end

  def validate_operation; end

  def instantiate_transfer
    @transfer = @transfer_model.new(operation_time: Time.now,
                                    operation_type: @params[:operation_type].to_sym,
                                    source_account_id: nil,
                                    dest_account_id: @current_account.id,
                                    sum: @params[:sum].to_f,
                                    comment: 'Replenishing account')
  end

  def commit_transaction
    @current_account.with_lock do
      @transfer.save!
      @current_account.balance += @params[:sum].to_f
      @current_account.save!
    end
  end
end

class ByAccountCreator < AbstractTransferCreator
  def set_source_account
    @source_account = @current_account
  end

  def set_destination_account
    @destination_account = Account.find_by(number: @params[:destination_account])
  end

  def validate_operation; end

  def instantiate_transfer
    @transfer = @transfer_model.new(operation_time: Time.now,
                                    operation_type: @params[:operation_type].to_sym,
                                    source_account_id: @source_account.id,
                                    dest_account_id: @destination_account.id,
                                    sum: @params[:sum].to_f,
                                    comment: '')
  end

  def commit_transaction
    @source_account.with_lock do
      @transfer.save!
      @source_account.balance -= @params[:sum].to_f
      @source_account.save!
      @destination_account.balance += @params[:sum].to_f
      @destination_account.save!
    end
  end
end

class ByCardCreator < AbstractTransferCreator
  def set_source_account
    @source_account = @current_account
  end

  def set_destination_account
    @destination_account = Card.find_by(number: @params[:card_number]).account
  end

  def validate_operation; end

  def instantiate_transfer
    @transfer = @transfer_model.new(operation_time: Time.now,
                                    operation_type: @params[:operation_type].to_sym,
                                    source_account_id: @source_account.id,
                                    dest_account_id: @destination_account.id,
                                    sum: @params[:sum].to_f,
                                    comment: '')
  end

  def commit_transaction
    @source_account.with_lock do
      @transfer.save!
      @source_account.balance -= @params[:sum].to_f
      @source_account.balance -= (@params[:sum].to_f / 100.0).round(2)  # fee
      @source_account.save!
      @destination_account.balance += @params[:sum].to_f
      @destination_account.save!
    end
  end
end

class ByPhoneCreator < AbstractTransferCreator
  def set_source_account
    @source_account = @current_account
  end

  def set_destination_account
    user = User.find_by(tel_number: @params[:phone_number])
    raise StandardError.new 'Phone number not found' unless user
    
    @destination_account = Account.joins(:user).where('users.id = ? AND accounts.main = TRUE', user.id).first

    return if @destination_account

    raise StandardError.new 'Account with such phone number not found'
  end

  def validate_operation; end

  def instantiate_transfer
    @transfer = @transfer_model.new(operation_time: Time.now,
                                    operation_type: @params[:operation_type].to_sym,
                                    source_account_id: @source_account.id,
                                    dest_account_id: @destination_account.id,
                                    sum: @params[:sum].to_f,
                                    comment: '')
  end

  def commit_transaction
    @source_account.with_lock do
      @transfer.save!
      @source_account.balance -= @params[:sum].to_f
      @source_account.save!
      @destination_account.balance += @params[:sum].to_f
      @destination_account.save!
    end
  end
end

class ToYourselfCreator < AbstractTransferCreator
  def set_source_account
    @source_account = @current_account
  end

  def set_destination_account
    @destination_account = Account.find_by(number: @params[:destination_account])
  end

  def validate_operation; end

  def instantiate_transfer
    @transfer = @transfer_model.new(operation_time: Time.now,
                                    operation_type: @params[:operation_type].to_sym,
                                    source_account_id: @source_account.id,
                                    dest_account_id: @destination_account.id,
                                    sum: @params[:sum].to_f,
                                    comment: '')
  end

  def commit_transaction
    @source_account.with_lock do
      @transfer.save!
      @source_account.balance -= @params[:sum].to_f
      @source_account.save!
      @destination_account.balance += @params[:sum].to_f
      @destination_account.save!
    end
  end
end

class PayCreator < AbstractTransferCreator
  def set_source_account
    @source_account = @current_account
  end

  def set_destination_account
    @destination_account = nil
  end

  def validate_operation; end

  def instantiate_transfer
    @transfer = @transfer_model.new(operation_time: Time.now,
                                    operation_type: @params[:operation_type].to_sym,
                                    source_account_id: @source_account.id,
                                    dest_account_id: nil,
                                    sum: @params[:sum].to_f,
                                    comment: @params[:comment])
  end

  def commit_transaction
    @source_account.with_lock do
      @transfer.save!
      @source_account.balance -= @params[:sum].to_f
      @source_account.save!
    end
  end
end
