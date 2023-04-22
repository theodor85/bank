# frozen_string_literal: true

class AccountService
  attr_reader :account, :errors

  def initialize(account_model, user_id)
    @account_model = account_model
    @user_id = user_id
  end

  def create(main: false)
    account = @account_model.new(user_id: @user_id,
                                 number: random_account_number,
                                 balance: 0.0,
                                 main:)
    return unless main

    ActiveRecord::Base.transaction do
      clear_main_flag(@user_id)
      account.save!
    end

    if account.persisted?
      @account = account
      true
    else
      @errors = account.errors
      false
    end
  end

  def update(account_id, main)
    account = @account_model.find(account_id)

    if main
      ActiveRecord::Base.transaction do
        clear_main_flag(@user_id)
        account.update!(main:)
      end
    else
      account.update(main:)
    end

    if account.persisted?
      @account = account
      true
    else
      @errors = account.errors
      false
    end
  end

  private

  def clear_main_flag(user_id)
    Account.user_accounts(user_id).update!(:all, main: false)
  end

  def random_account_number
    10.times.map { rand(10) }.join.to_i
  end
end
