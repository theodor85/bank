# frozen_string_literal: true

class CardsController < ApplicationController
  include CardsHelper

  before_action :authenticate_user!
  before_action :authorize

  def new
    @card = Card.new
  end

  def create
    @card = Card.new(account_id: @account.id,
                     number: rand_card_number,
                     cvv: rans_cvv,
                     end_date: Time.now + 3.years)

    respond_to do |format|
      if @card.save
        format.html { redirect_to account_url(@account.id), notice: 'Card was successfully created.' }
        format.json { render :show, status: :created, location: @card }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @card.errors, status: :unprocessable_entity }
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
end
