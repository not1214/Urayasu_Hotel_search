class Public::MembersController < ApplicationController
  before_action :authenticate_member!

  def mypage
    @member = current_member
    @reviews = @member.reviews.order("created_at DESC").page(params[:page]).per(5)
  end

  def show
    @member = Member.find_by(username: params[:username])
    @reviews = @member.reviews.where(review_image_status: false).order("created_at DESC").page(params[:page]).per(5)
  end

  def edit
    @member = current_member
    # binding.pry
    if @member != current_member
      flash[:alert] = '不正なアクセスです。'
      redirect_to "/#{@member.username}"
    end
  end

  def update
    @member = current_member
    # binding.pry
    if @member.update(member_params)
      # binding.pry
      flash[:notice] = '会員情報を更新しました。'
      redirect_to mypage_path

      if Vision.image_analysis(@member.profile_image)
        @member.update(profile_image_status: true)
        flash[:notice] = nil
        flash[:alert] = "不適切な画像です。マイページから画像を変更してください。"
      else
        @member.update(profile_image_status: false)
      end
    else
      flash.now[:alert] = '会員情報を更新できませんでした。'
      render :edit
    end
  end

  def unsubscribe
    @member = current_member
    if @member != current_member
      flash[:alert] = '不正なアクセスです。'
      redirect_to "/#{@member.username}"
    end
  end

  def withdraw
    @member = current_member
    # binding.pry
    @member.update(is_deleted: true)
    reset_session
    flash[:notice] = '退会しました。'
    redirect_to root_path
  end

  def favorites
    @member = current_member
    @favorites = current_member.favorites.pluck(:hotel_id)
    # binding.pry
    @favorite_hotels = Hotel.includes(:area, :category).find(@favorites)
  end

  private

  def member_params
    params.require(:member).permit(:username, :last_name, :first_name, :last_name_kana, :first_name_kana,
                                   :phone_number, :profile_image, :introduction)
  end
end
