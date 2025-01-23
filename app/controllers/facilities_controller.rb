class FacilitiesController < ApplicationController
  def index
    @facilities = Facility.all # 必要に応じて現在のユーザーの施設のみを取得
  end

  def new
    @facility = Facility.new
  end

  def create
    @facility = Facility.new(facility_params)
    if @facility.save
      # 保存成功時に予約作成フォームへリダイレクト
      redirect_to new_booking_path(facility_id: @facility.id), notice: '施設が作成されました。次に予約を作成してください。'
    else
      # 保存失敗時はフォームを再表示
      render :new
    end
  end

  def destroy
    @facility = Facility.find(params[:id])
    @facility.destroy
    redirect_to facilities_path, notice: '施設を削除しました。'
  end

  private

  def facility_params
    params.require(:facility).permit(:name, :description, :location, :price, :image)
  end
end
