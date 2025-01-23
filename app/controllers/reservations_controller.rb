class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reservation, only: [:show]

  def new
    @room = Room.find_by(id: params[:room_id])
    if @room.nil?
      redirect_to rooms_path, alert: '該当する部屋が見つかりませんでした。'
    else
      @reservation = @room.reservations.build
    end
  end

  def confirm
    @room = Room.find_by(id: params[:room_id])
    if @room.nil?
      redirect_to rooms_path, alert: '該当する部屋が見つかりませんでした。'
      return
    end

    @reservation = @room.reservations.new(reservation_params.merge(user_id: current_user.id))
    if @reservation.invalid?
      flash.now[:alert] = @reservation.errors.full_messages.join(', ')
      render :new
    end
  end

  def create
    @room = Room.find_by(id: params[:room_id])
    if @room.nil?
      redirect_to rooms_path, alert: '該当する部屋が見つかりませんでした。'
      return
    end
  
    # パラメータから予約情報を設定
    @reservation = @room.reservations.new(reservation_params.merge(user_id: current_user.id))
  
    if params[:reservation][:step] == 'confirm' # 確定処理
      if @reservation.save
        redirect_to reservations_path, notice: '予約が確定しました。'
      else
        flash.now[:alert] = @reservation.errors.full_messages.join(', ')
        render :confirm
      end
    else # 確認画面の表示
      if @reservation.valid?
        render :confirm
      else
        flash.now[:alert] = @reservation.errors.full_messages.join(', ')
        render :new
      end
    end
  end

  def index
    @reservations = current_user.reservations
  end

  def destroy
    @reservation = current_user.reservations.find_by(id: params[:id])
    if @reservation
      @reservation.destroy
      redirect_to reservations_path, notice: '予約を削除しました。'
    else
      redirect_to reservations_path, alert: '予約が見つかりませんでした。'
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(:check_in, :check_out, :number_of_guests)
  end
end