require 'test_helper'

class FiveminuteTimedAssetsControllerTest < ActionController::TestCase
  setup do
    @fiveminute_timed_asset = fiveminute_timed_assets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fiveminute_timed_assets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fiveminute_timed_asset" do
    assert_difference('FiveminuteTimedAsset.count') do
      post :create, fiveminute_timed_asset: { Advanced_Mining_Corp: @fiveminute_timed_asset.Advanced_Mining_Corp, AsicMiner: @fiveminute_timed_asset.AsicMiner, AsicMiner_small: @fiveminute_timed_asset.AsicMiner_small, BTC: @fiveminute_timed_asset.BTC, LTC: @fiveminute_timed_asset.LTC, NMC: @fiveminute_timed_asset.NMC, PPC: @fiveminute_timed_asset.PPC, XPM: @fiveminute_timed_asset.XPM, comment: @fiveminute_timed_asset.comment, misc1: @fiveminute_timed_asset.misc1, misc2: @fiveminute_timed_asset.misc2, misc3: @fiveminute_timed_asset.misc3, time_changed: @fiveminute_timed_asset.time_changed }
    end

    assert_redirected_to fiveminute_timed_asset_path(assigns(:fiveminute_timed_asset))
  end

  test "should show fiveminute_timed_asset" do
    get :show, id: @fiveminute_timed_asset
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @fiveminute_timed_asset
    assert_response :success
  end

  test "should update fiveminute_timed_asset" do
    patch :update, id: @fiveminute_timed_asset, fiveminute_timed_asset: { Advanced_Mining_Corp: @fiveminute_timed_asset.Advanced_Mining_Corp, AsicMiner: @fiveminute_timed_asset.AsicMiner, AsicMiner_small: @fiveminute_timed_asset.AsicMiner_small, BTC: @fiveminute_timed_asset.BTC, LTC: @fiveminute_timed_asset.LTC, NMC: @fiveminute_timed_asset.NMC, PPC: @fiveminute_timed_asset.PPC, XPM: @fiveminute_timed_asset.XPM, comment: @fiveminute_timed_asset.comment, misc1: @fiveminute_timed_asset.misc1, misc2: @fiveminute_timed_asset.misc2, misc3: @fiveminute_timed_asset.misc3, time_changed: @fiveminute_timed_asset.time_changed }
    assert_redirected_to fiveminute_timed_asset_path(assigns(:fiveminute_timed_asset))
  end

  test "should destroy fiveminute_timed_asset" do
    assert_difference('FiveminuteTimedAsset.count', -1) do
      delete :destroy, id: @fiveminute_timed_asset
    end

    assert_redirected_to fiveminute_timed_assets_path
  end
end
