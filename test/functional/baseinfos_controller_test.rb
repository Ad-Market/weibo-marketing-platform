require 'test_helper'

class BaseinfosControllerTest < ActionController::TestCase
  setup do
    @baseinfo = baseinfos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:baseinfos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create baseinfo" do
    assert_difference('Baseinfo.count') do
      post :create, baseinfo: { allow_all_act_msg: @baseinfo.allow_all_act_msg, allow_all_comment: @baseinfo.allow_all_comment, avatar_large: @baseinfo.avatar_large, bi_followers_count: @baseinfo.bi_followers_count, bi_followers_count: @baseinfo.bi_followers_count, city: @baseinfo.city, created_at: @baseinfo.created_at, description: @baseinfo.description, domain: @baseinfo.domain, favourites_count: @baseinfo.favourites_count, follow_me: @baseinfo.follow_me, followers_count: @baseinfo.followers_count, following: @baseinfo.following, friends_count: @baseinfo.friends_count, gender: @baseinfo.gender, geo_enabled: @baseinfo.geo_enabled, id: @baseinfo.id, location: @baseinfo.location, name: @baseinfo.name, profile_image_url: @baseinfo.profile_image_url, province: @baseinfo.province, remark: @baseinfo.remark, screen_name: @baseinfo.screen_name, statuses_count: @baseinfo.statuses_count, url: @baseinfo.url, verified: @baseinfo.verified, verified_reason: @baseinfo.verified_reason }
    end

    assert_redirected_to baseinfo_path(assigns(:baseinfo))
  end

  test "should show baseinfo" do
    get :show, id: @baseinfo
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @baseinfo
    assert_response :success
  end

  test "should update baseinfo" do
    put :update, id: @baseinfo, baseinfo: { allow_all_act_msg: @baseinfo.allow_all_act_msg, allow_all_comment: @baseinfo.allow_all_comment, avatar_large: @baseinfo.avatar_large, bi_followers_count: @baseinfo.bi_followers_count, bi_followers_count: @baseinfo.bi_followers_count, city: @baseinfo.city, created_at: @baseinfo.created_at, description: @baseinfo.description, domain: @baseinfo.domain, favourites_count: @baseinfo.favourites_count, follow_me: @baseinfo.follow_me, followers_count: @baseinfo.followers_count, following: @baseinfo.following, friends_count: @baseinfo.friends_count, gender: @baseinfo.gender, geo_enabled: @baseinfo.geo_enabled, id: @baseinfo.id, location: @baseinfo.location, name: @baseinfo.name, profile_image_url: @baseinfo.profile_image_url, province: @baseinfo.province, remark: @baseinfo.remark, screen_name: @baseinfo.screen_name, statuses_count: @baseinfo.statuses_count, url: @baseinfo.url, verified: @baseinfo.verified, verified_reason: @baseinfo.verified_reason }
    assert_redirected_to baseinfo_path(assigns(:baseinfo))
  end

  test "should destroy baseinfo" do
    assert_difference('Baseinfo.count', -1) do
      delete :destroy, id: @baseinfo
    end

    assert_redirected_to baseinfos_path
  end
end
