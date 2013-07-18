class UserInfosController < ApplicationController
  def NUKE
    UserInfo.all.destroy_all

    UserInfo.create(
      :user => "hak8or",
      :pass => "Coolpassword",
      :BTC => 1.2,
      :LTC => 15.3,
      :PPC => 60,
      :NMC => 15,
      :XPM => 180,
      :AsicMiner => 1,
      :AsicMiner_small => 13,
      :Advanced_Mining_Corp => 470,
      :misc1 => 0,
      :misc2 => 0,
      :misc3 => 0,
      :comment => "First Post!",
      :time_changed => Time.now
    )

    respond_to do |format|
      format.html { redirect_to user_infos_url }
      format.json { head :no_content }
    end
  end

  before_action :set_user_info, only: [:show, :edit, :update, :destroy]

  # GET /user_infos
  # GET /user_infos.json
  def index
    @user_infos = UserInfo.first(200)
  end

  # GET /user_infos/1
  # GET /user_infos/1.json
  def show
  end

  # GET /user_infos/new
  def new
    @user_info = UserInfo.new
  end

  # GET /user_infos/1/edit
  def edit
  end

  # POST /user_infos
  # POST /user_infos.json
  def create
    @user_info = UserInfo.new(user_info_params)

    respond_to do |format|
      if @user_info.save
        format.html { redirect_to @user_info, notice: 'User info was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user_info }
      else
        format.html { render action: 'new' }
        format.json { render json: @user_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_infos/1
  # PATCH/PUT /user_infos/1.json
  def update
    respond_to do |format|
      if @user_info.update(user_info_params)
        format.html { redirect_to @user_info, notice: 'User info was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_infos/1
  # DELETE /user_infos/1.json
  def destroy
    @user_info.destroy
    respond_to do |format|
      format.html { redirect_to user_infos_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_info
      @user_info = UserInfo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_info_params
      params.require(:user_info).permit(:user, :pass, :BTC, :LTC, :PPC, :NMC, 
        :XPM, :AsicMiner, :AsicMiner_small, :Advanced_Mining_Corp, :misc1, 
        :misc2, :misc3, :comment, :time_changed)
    end
end
