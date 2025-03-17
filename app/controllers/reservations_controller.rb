class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reservation, only: [:show, :destroy, :update]

  def new
    @room = Room.find_by(id: params[:room_id])
    if @room.nil?
      redirect_to rooms_path, alert: '該当する部屋が見つかりませんでした。'
    else
      @reservation = @room.reservations.build
    end
  end

  def show
    @room = @reservation.room
  end

  def confirm
    @reservation = Reservation.find_by(id: params[:id])
    if @reservation.nil?
      redirect_to reservations_path, alert: '予約が見つかりませんでした。'
    else
      @room = @reservation.room
    end
  end

  def create
    @room = Room.find_by(id: params[:room_id])
    if @room.nil?
      redirect_to rooms_path, alert: '該当する部屋が見つかりませんでした。'
      return
    end

    @reservation = @room.reservations.new(reservation_params.merge(user_id: current_user.id))

    if @reservation.save
      redirect_to reservation_path(@reservation), notice: '予約が作成されました。'
    else
      flash.now[:alert] = @reservation.errors.full_messages.join(', ')
      render :new
    end
  end

  def update
    if @reservation.update(reservation_params)
      redirect_to reservations_path, notice: '予約が確定しました。'
    else
      flash.now[:alert] = @reservation.errors.full_messages.join(', ')
      render :show
    end
  end

  def index
    @reservations = current_user.reservations
  end

  def destroy
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

  def set_reservation
    @reservation = Reservation.find_by(id: params[:id])
    redirect_to reservations_path, alert: '予約が見つかりませんでした。' unless @reservation
  end
end