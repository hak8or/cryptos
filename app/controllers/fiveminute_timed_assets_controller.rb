class FiveminuteTimedAssetsController < ApplicationController
  before_action :set_fiveminute_timed_asset, only: [:show, :edit, :update, :destroy]

  # GET /fiveminute_timed_assets
  # GET /fiveminute_timed_assets.json
  def index
    @fiveminute_timed_assets = FiveminuteTimedAsset.last(900)
  end

  # GET /fiveminute_timed_assets/1
  # GET /fiveminute_timed_assets/1.json
  def show
  end

  # GET /fiveminute_timed_assets/new
  def new
    @fiveminute_timed_asset = FiveminuteTimedAsset.new
  end

  # GET /fiveminute_timed_assets/1/edit
  def edit
  end

  # POST /fiveminute_timed_assets
  # POST /fiveminute_timed_assets.json
  def create
    @fiveminute_timed_asset = FiveminuteTimedAsset.new(fiveminute_timed_asset_params)

    respond_to do |format|
      if @fiveminute_timed_asset.save
        format.html { redirect_to @fiveminute_timed_asset, notice: 'Fiveminute timed asset was successfully created.' }
        format.json { render action: 'show', status: :created, location: @fiveminute_timed_asset }
      else
        format.html { render action: 'new' }
        format.json { render json: @fiveminute_timed_asset.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fiveminute_timed_assets/1
  # PATCH/PUT /fiveminute_timed_assets/1.json
  def update
    respond_to do |format|
      if @fiveminute_timed_asset.update(fiveminute_timed_asset_params)
        format.html { redirect_to @fiveminute_timed_asset, notice: 'Fiveminute timed asset was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @fiveminute_timed_asset.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fiveminute_timed_assets/1
  # DELETE /fiveminute_timed_assets/1.json
  def destroy
    @fiveminute_timed_asset.destroy
    respond_to do |format|
      format.html { redirect_to fiveminute_timed_assets_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fiveminute_timed_asset
      @fiveminute_timed_asset = FiveminuteTimedAsset.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fiveminute_timed_asset_params
      params.require(:fiveminute_timed_asset).permit(:BTC, :LTC, :PPC, :NMC, :XPM, :AsicMiner, :AsicMiner_small, :Advanced_Mining_Corp, :misc1, :misc2, :misc3, :comment, :time_changed)
    end
end
