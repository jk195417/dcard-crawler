require "application_system_test_case"

class Admin::PostsTest < ApplicationSystemTestCase
  setup do
    @admin_post = admin_posts(:one)
  end

  test "visiting the index" do
    visit admin_posts_url
    assert_selector "h1", text: "Admin/Posts"
  end

  test "creating a Post" do
    visit admin_posts_url
    click_on "New Admin/Post"

    click_on "Create Post"

    assert_text "Post was successfully created"
    click_on "Back"
  end

  test "updating a Post" do
    visit admin_posts_url
    click_on "Edit", match: :first

    click_on "Update Post"

    assert_text "Post was successfully updated"
    click_on "Back"
  end

  test "destroying a Post" do
    visit admin_posts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Post was successfully destroyed"
  end
end
