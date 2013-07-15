require 'test_helper'

class UserInfosControllerTest < ActionController::TestCase
  setup do
    @user_info = user_infos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_infos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_info" do
    assert_difference('UserInfo.count') do
      post :create, user_info: { Advanced_Mining_Corp: @user_info.Advanced_Mining_Corp, AsicMiner: @user_info.AsicMiner, AsicMiner_small: @user_info.AsicMiner_small, BTC: @user_info.BTC, LTC: @user_info.LTC, NMC: @user_info.NMC, PPC: @user_info.PPC, XPM: @user_info.XPM, comment: @user_info.comment, misc1: @user_info.misc1, misc2: @user_info.misc2, misc3: @user_info.misc3, pass: @user_info.pass, time_changed: @user_info.time_changed, user: @user_info.user }
    end

    assert_redirected_to user_info_path(assigns(:user_info))
  end

  test "should show user_info" do
    get :show, id: @user_info
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user_info
    assert_response :success
  end

  test "should update user_info" do
    patch :update, id: @user_info, user_info: { Advanced_Mining_Corp: @user_info.Advanced_Mining_Corp, AsicMiner: @user_info.AsicMiner, AsicMiner_small: @user_info.AsicMiner_small, BTC: @user_info.BTC, LTC: @user_info.LTC, NMC: @user_info.NMC, PPC: @user_info.PPC, XPM: @user_info.XPM, comment: @user_info.comment, misc1: @user_info.misc1, misc2: @user_info.misc2, misc3: @user_info.misc3, pass: @user_info.pass, time_changed: @user_info.time_changed, user: @user_info.user }
    assert_redirected_to user_info_path(assigns(:user_info))
  end

  test "should destroy user_info" do
    assert_difference('UserInfo.count', -1) do
      delete :destroy, id: @user_info
    end

    assert_redirected_to user_infos_path
  end
end
