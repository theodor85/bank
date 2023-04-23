# frozen_string_literal: true

class TransfersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account
  before_action :set_transfer, only: %i[show edit update destroy]
  before_action :set_service

  def index
    @transfers = Transfer.account_transfers(@account.id)
  end

  def show; end

  def new
    @transfer = @service.new_transfer(params[:type].to_sym)
    @user_accounts = Account.user_accounts(current_user.id)
    respond_to do |format|
      if @service.error
        format.html { redirect_to account_url(@account), notice: @service.error }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit; end

  # POST /transfers or /transfers.json
  def create
    @transfer = Transfer.new(transfer_params)

    respond_to do |format|
      if @transfer.save
        format.html { redirect_to transfer_url(@transfer), notice: 'Transfer was successfully created.' }
        format.json { render :show, status: :created, location: @transfer }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @transfer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transfers/1 or /transfers/1.json
  def update
    respond_to do |format|
      if @transfer.update(transfer_params)
        format.html { redirect_to transfer_url(@transfer), notice: 'Transfer was successfully updated.' }
        format.json { render :show, status: :ok, location: @transfer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @transfer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transfers/1 or /transfers/1.json
  def destroy
    @transfer.destroy

    respond_to do |format|
      format.html { redirect_to transfers_url, notice: 'Transfer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_account
    @account = Account.find(params[:account_id])
  end

  def set_transfer
    @transfer = Transfer.find(params[:id])
  end

  def transfer_params
    params.require(:transfer).permit(:operation_time, :operation_type, :source_acc_id_id, :dest_acc_id_id, :sum,
                                     :comment)
  end

  def set_service
    @service = TransferService.new(Transfer, @account)
  end
end
