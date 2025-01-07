class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reservation, only: [:show]

  def new
    @room = Room.find(params[:room_id])
    @reservation = @room.reservations.build
  end

  def create
    @room = Room.find(params[:room_id])
    @reservation = current_user.reservations.build(reservation_params.merge(room: @room))

    if @reservation.save
      redirect_to reservation_path(@reservation), notice: '予約が完了しました。'
    else
      render :new
    end
  end

  def index
    @reservations = current_user.reservations
  end

  def show; end

  private

  def set_reservation
    @reservation = current_user.reservations.find(params[:id])
  end

  def reservation_params
    params.require(:reservation).permit(:check_in, :check_out, :number_of_guests)
  end
end