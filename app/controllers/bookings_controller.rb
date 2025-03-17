class BookingsController < ApplicationController
  before_action :set_facility, only: [:new]

  def index
    @bookings = Booking.includes(:facility, :user).all
  end

  def new
    @facility = Facility.find_by(id: params[:facility_id])
    @booking = Booking.new(facility_id: @facility&.id)

    if @facility.nil?
      flash[:alert] = '施設が見つかりませんでした。'
      redirect_to facilities_path and return
    end
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.user_id = current_user.id 

    if @booking.facility_id.nil?
      flash[:alert] = "施設が選択されていません。"
      redirect_to new_booking_path and return
    end

    # 該当施設に紐づく部屋を取得
    room = Room.find_by(facility_id: @booking.facility_id)

    if room.nil?
      # 部屋が存在しない場合はエラーを記録し、一覧ページにリダイレクト
      Rails.logger.error("エラー: Roomが見つかりません facility_id=#{@booking.facility_id}")
      flash[:alert] = '対応する部屋が見つかりませんでした。管理者にお問い合わせください。'
      redirect_to facilities_path and return
    end

    if @booking.save
      # 予約が成功した場合、予約情報を作成し予約済み一覧ページにリダイレクト
      @reservation = Reservation.create!(
        room_id: room.id,
        user_id: @booking.user_id,
        check_in: @booking.start_date,
        check_out: @booking.end_date,
        number_of_guests: @booking.number_of_people
      )
      redirect_to reservations_path, notice: '予約が作成されました。'
    else
      # 保存が失敗した場合はフォームを再表示
      Rails.logger.error("Booking save failed: #{@booking.errors.full_messages.join(', ')}")
      flash.now[:alert] = '予約作成に失敗しました。入力内容を確認してください。'
      render :new
    end
  end

  private

  def set_facility
    return if params[:facility_id].blank?

    @facility = Facility.find_by(id: params[:facility_id])
    if @facility.nil?
      flash[:alert] = '指定された施設が見つかりませんでした。'
      redirect_to facilities_path and return
    end
  end

  def booking_params
    params.require(:booking).permit(:facility_id, :start_date, :end_date, :number_of_people)
  end
end