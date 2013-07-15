class TimedAssetsController < ApplicationController
  before_action :set_timed_asset, only: [:show, :edit, :update, :destroy]

  # GET /timed_assets
  # GET /timed_assets.json
  def index
    @timed_assets = TimedAsset.last(900)
  end

  # GET /timed_assets/1
  # GET /timed_assets/1.json
  def show
  end

  # GET /timed_assets/new
  def new
    @timed_asset = TimedAsset.new
  end

  # GET /timed_assets/1/edit
  def edit
  end

  # POST /timed_assets
  # POST /timed_assets.json
  def create
    @timed_asset = TimedAsset.new(timed_asset_params)

    respond_to do |format|
      if @timed_asset.save
        format.html { redirect_to @timed_asset, notice: 'Timed asset was successfully created.' }
        format.json { render action: 'show', status: :created, location: @timed_asset }
      else
        format.html { render action: 'new' }
        format.json { render json: @timed_asset.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /timed_assets/1
  # PATCH/PUT /timed_assets/1.json
  def update
    respond_to do |format|
      if @timed_asset.update(timed_asset_params)
        format.html { redirect_to @timed_asset, notice: 'Timed asset was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @timed_asset.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /timed_assets/1
  # DELETE /timed_assets/1.json
  def destroy
    @timed_asset.destroy
    respond_to do |format|
      format.html { redirect_to timed_assets_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_timed_asset
      @timed_asset = TimedAsset.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def timed_asset_params
      params.require(:timed_asset).permit(:BTC, :LTC, :PPC, :NMC, :XPM, :AsicMiner, :AsicMiner_small, :Advanced_Mining_Corp, :misc1, :misc2, :misc3, :comment, :time_changed)
    end
end
