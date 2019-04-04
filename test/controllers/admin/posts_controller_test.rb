require 'test_helper'

class Admin::PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_post = admin_posts(:one)
  end

  test "should get index" do
    get admin_posts_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_post_url
    assert_response :success
  end

  test "should create admin_post" do
    assert_difference('Admin::Post.count') do
      post admin_posts_url, params: { admin_post: {  } }
    end

    assert_redirected_to admin_post_url(Admin::Post.last)
  end

  test "should show admin_post" do
    get admin_post_url(@admin_post)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_post_url(@admin_post)
    assert_response :success
  end

  test "should update admin_post" do
    patch admin_post_url(@admin_post), params: { admin_post: {  } }
    assert_redirected_to admin_post_url(@admin_post)
  end

  test "should destroy admin_post" do
    assert_difference('Admin::Post.count', -1) do
      delete admin_post_url(@admin_post)
    end

    assert_redirected_to admin_posts_url
  end
end
