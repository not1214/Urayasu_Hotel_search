class Public::HotelsController < ApplicationController
  before_action :authenticate_member!, except: [:index]

  def index
    @hotels = Hotel.includes(:area, :category).page(params[:page]).per(12)
    # binding.pry
    @categories = Category.all
    @areas = Area.all
    gon.hotels = Hotel.all
  end

  def show
    @hotel = Hotel.find(params[:id])
    gon.hotel = Hotel.find(params[:id])
  end

  def ranking
    @rate_ranks = Hotel.includes(:area,
                                 :category).find(Review.group(:hotel_id).order('avg(rate) desc').limit(5).pluck(:hotel_id))
    @favorite_ranks = Hotel.includes(:area,
                                     :category).find(Favorite.group(:hotel_id).order('count(hotel_id) desc').limit(5).pluck(:hotel_id))
  end
end
