# frozen_string_literal: true

class TransfersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize
  before_action :set_service

  def new
    @transfer = @service.new_transfer(params[:type].to_sym)
    @user_accounts = Account.user_accounts(current_user.id)
    respond_to do |format|
      if @service.error
        format.html { redirect_to account_url(@account), notice: @service.error }
      else
        format.html { render :new }
      end
    end
  end

  def create
    respond_to do |format|
      if @service.create_transfer(transfer_params)
        format.html { redirect_to account_url(@account), notice: 'Transfer was successfully created.' }
        format.json { render :show, status: :created, location: @account }
      else
        format.html do
          redirect_to new_account_transfer_path(@account, type: transfer_params[:operation_type]), alert: @service.error
        end
        format.json { render json: error, status: :unprocessable_entity }
      end
    end
  end

  private

  def authorize
    @account = Account.find(params[:account_id])

    unless @account.user == current_user
      redirect_to accounts_url, alert: 'Access denied'
    end
  end

  def transfer_params
    params.require(:transfer).permit(:operation_time, :operation_type, :source_account, :destination_account, :sum,
                                     :comment, :card_number, :phone_number, :comment)
  end

  def set_service
    @service = TransferService.new(Transfer, @account)
  end
end
