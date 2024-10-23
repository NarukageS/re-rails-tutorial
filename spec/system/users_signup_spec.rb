require 'rails_helper'

RSpec.describe 'ユーザー登録', type: :system do
  scenario "無効なユーザー" do
    visit signup_path
    before_count = User.count

    post users_path, params: { user: { name:  "",
                                      email: "user@invalid",
                                      password:              "foo",
                                      password_confirmation: "bar" } }
    
    after_count = User.count
    expect(after_count).to eq(before_count)
  end

  scenario "有効なユーザー" do
    visit signup_path
    before_count = User.count

    post users_path, params: { user: { name:  "Example User",
                               email: "user@example.com",
                               password:              "password",
                               password_confirmation: "password" } }
    after_count = User.count
    expect(after_count).to eq(before_count + 1)
    expect(response).to redirect_to(User.last)
  end
end