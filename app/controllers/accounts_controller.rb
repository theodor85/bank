# frozen_string_literal: true

class AccountsController < ApplicationController
  include AccountsHelper

  before_action :authenticate_user!
  before_action :authorize, only: %i[show edit update]

  # GET /accounts or /accounts.json
  def index
    @accounts = Account.user_accounts(current_user.id).includes([:card, :user])
  end

  # GET /accounts/1 or /accounts/1.json
  def show
    @transfer_list = AccountService.new(Account, current_user.id).transfer_list(@account)
  end

  # GET /accounts/new
  def new
    @account = Account.new
  end

  # GET /accounts/1/edit
  def edit; end

  # POST /accounts or /accounts.json
  def create
    account_service = AccountService.new(Account, current_user.id)
    respond_to do |format|
      if account_service.create(main: account_params[:main])
        format.html { redirect_to account_url(account_service.account), notice: 'Account was successfully created.' }
        format.json { render :show, status: :created, location: account_service.account }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: account_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accounts/1 or /accounts/1.json
  def update
    account_service = AccountService.new(Account, current_user.id)

    respond_to do |format|
      if account_service.update(@account.id, account_params[:main])
        format.html { redirect_to account_url(account_service.account), notice: 'Account was successfully updated.' }
        format.json { render :show, status: :ok, location: account_service.account }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: account_service.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def authorize
    @account = Account.find(params[:id])

    unless @account.user == current_user
      redirect_to accounts_url, alert: 'Access denied'
    end
  end

  def account_params
    params.require(:account).permit(:id, :main)
  end
end
