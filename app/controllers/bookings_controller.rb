class BookingsController < ApplicationController
    before_action :set_facility, only: [:new, :create]
  
    def new
      @booking = Booking.new
      redirect_to root_path, alert: '施設が見つかりませんでした。' if @facility.nil?
    end
  
    def create
      @booking = Booking.new(booking_params)
      @booking.user_id = current_user.id # ログイン中のユーザーを関連付け
  
      if @booking.save
        redirect_to root_path, notice: '予約が作成されました。'
      else
        render :new
      end
    end
  
    private
  
    def set_facility
      @facility = Facility.find_by(id: params[:facility_id])
    end
  
    def booking_params
      params.require(:booking).permit(:facility_id, :start_date, :end_date, :number_of_people)
    end
  end
