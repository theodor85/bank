# frozen_string_literal: true

class CardsController < ApplicationController
  include CardsHelper

  before_action :set_account
  before_action :set_card, only: %i[edit destroy]

  def new
    @card = Card.new
  end

  def edit; end

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

  def destroy
    @card.destroy

    respond_to do |format|
      format.html { redirect_to cards_url, notice: 'Card was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_card
    @card = Card.find(params[:id])
  end

  def set_account
    @account = Account.find(params[:account_id])
  end
end
