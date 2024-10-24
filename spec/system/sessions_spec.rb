require 'rails_helper'
 
RSpec.describe "Sessions", type: :system do
  before do
    driven_by(:rack_test)
  end
 
  describe '#new' do
    context '無効な値の場合' do
      it 'flashメッセージが表示される' do
        visit login_path
 
        fill_in 'Email', with: ''
        fill_in 'Password', with: ''
        click_button 'Log in'

        expect(page).to have_selector 'div.alert.alert-danger'

        visit root_path
        expect(page).to_not have_selector 'div.alert.alert-danger'
      end
    end

    context '有効な値の場合' do
      let(:user) { FactoryBot.create(:user) }
     
      it 'ログインユーザ用のページが表示されること' do
        visit login_path
     
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        click_button 'Log in'
     
        expect(page).to_not have_selector "a[href=\"#{login_path}\"]"
        expect(page).to have_selector "a[href=\"#{logout_path}\"]"
        expect(page).to have_selector "a[href=\"#{user_path(user)}\"]"
      end
    end
  end

  describe 'DELETE /logout' do
    it 'ログアウトできること' do
      user = FactoryBot.create(:user)
      post login_path, params: { session: { email: user.email,
                                            password: user.password } }
      expect(logged_in?).to be_truthy
 
      delete logout_path
      expect(logged_in?).to_not be_truthy
    end
  end
end