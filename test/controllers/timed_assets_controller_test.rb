require 'test_helper'

class TimedAssetsControllerTest < ActionController::TestCase
  setup do
    @timed_asset = timed_assets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:timed_assets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create timed_asset" do
    assert_difference('TimedAsset.count') do
      post :create, timed_asset: { Advanced_Mining_Corp: @timed_asset.Advanced_Mining_Corp, AsicMiner: @timed_asset.AsicMiner, AsicMiner_small: @timed_asset.AsicMiner_small, BTC: @timed_asset.BTC, LTC: @timed_asset.LTC, NMC: @timed_asset.NMC, PPC: @timed_asset.PPC, XPM: @timed_asset.XPM, comment: @timed_asset.comment, misc1: @timed_asset.misc1, misc2: @timed_asset.misc2, misc3: @timed_asset.misc3, time_changed: @timed_asset.time_changed }
    end

    assert_redirected_to timed_asset_path(assigns(:timed_asset))
  end

  test "should show timed_asset" do
    get :show, id: @timed_asset
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @timed_asset
    assert_response :success
  end

  test "should update timed_asset" do
    patch :update, id: @timed_asset, timed_asset: { Advanced_Mining_Corp: @timed_asset.Advanced_Mining_Corp, AsicMiner: @timed_asset.AsicMiner, AsicMiner_small: @timed_asset.AsicMiner_small, BTC: @timed_asset.BTC, LTC: @timed_asset.LTC, NMC: @timed_asset.NMC, PPC: @timed_asset.PPC, XPM: @timed_asset.XPM, comment: @timed_asset.comment, misc1: @timed_asset.misc1, misc2: @timed_asset.misc2, misc3: @timed_asset.misc3, time_changed: @timed_asset.time_changed }
    assert_redirected_to timed_asset_path(assigns(:timed_asset))
  end

  test "should destroy timed_asset" do
    assert_difference('TimedAsset.count', -1) do
      delete :destroy, id: @timed_asset
    end

    assert_redirected_to timed_assets_path
  end
end
