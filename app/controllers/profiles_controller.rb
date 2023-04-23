# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show; end

  def edit; end

  def update
    respond_to do |format|
      if current_user.update(tel_number: user_params[:tel_number])
        format.html { redirect_to profile_url(current_user), notice: 'Profile was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:tel_number)
  end
end
