class FacilitiesController < ApplicationController
  def index
    @facilities = Facility.all
  end

  def new
    @facility = Facility.new
  end

  def create
    @facility = Facility.new(facility_params)
  
    if @facility.save
      flash[:notice] = '施設が作成されました。'
      redirect_to facilities_path # 施設一覧画面にリダイレクト
    else
      flash.now[:alert] = @facility.errors.full_messages.join(', ')
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @facility = Facility.find(params[:id])
  end

  def update
    @facility = Facility.find(params[:id])

    if @facility.update(facility_params)
      # 施設に関連する部屋がある場合は、その部屋の予約フォームにリダイレクト
      room = Room.find_by(facility_id: @facility.id)
      if room
        redirect_to new_room_reservation_path(room), notice: '施設情報が更新されました。予約を作成してください。'
      else
        redirect_to new_booking_path(facility_id: @facility.id), notice: '施設情報が更新されました。予約を作成してください。'
      end
    else
      flash.now[:alert] = @facility.errors.full_messages.join(', ')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @facility = Facility.find(params[:id])
    @facility.destroy
    redirect_to facilities_path, notice: '施設を削除しました。'
  end

  #追加: registered アクション
  def registered
    @facilities = Facility.all
    render :index
  end

  private

  def facility_params
    params.require(:facility).permit(:name, :description, :location, :price, :image)
  end
end
