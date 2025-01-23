class RoomsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_room, only: [:show]

  def index
    @q = Room.ransack(params[:q]) # Ransack 検索オブジェクトを作成
    @rooms = @q.result.order(created_at: :desc) # 全ての部屋を表示
  end

  def show
    @room = Room.find(params[:id]) # 部屋の情報を取得
    @reservation = @room.reservations.build # 部屋に関連する新しい予約を作成
  end

  def new
    @room = Room.new
  end

  def create
    @room = current_user.rooms.build(room_params)
    if @room.save
      redirect_to @room, notice: '施設を登録しました。'
    else
      flash.now[:alert] = @room.errors.full_messages.join(", ")
      render :new
    end
  end

  private

  def set_room
    @room = Room.find(params[:id])
    # 他のユーザーの施設へのアクセスを制限する場合
    # redirect_to rooms_path, alert: "アクセス権がありません。" unless @room.user == current_user
  end

  def room_params
    params.require(:room).permit(:name, :description, :price, :address, :image)
  end
end

