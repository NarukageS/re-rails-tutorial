require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET #index" do
    context "未ログイン時" do
      it "リダイレクトされること" do
        get users_path
        expect(response).to redirect_to login_url
      end
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get signup_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    let(:user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:user, name: "archer", email: "testtest@test.com")}

    context "未ログイン時" do
      it "ログインページへリダイレクトされること" do
        get edit_user_path(user)
        expect(response).to redirect_to login_path
      end

      it "ログイン後編集ページにリダイレクトされること" do
        get edit_user_path(user)
        log_in user
        expect(response).to redirect_to edit_user_path(user)
      end
    end

    context "ログイン時" do
      before do
        log_in user
      end

      it 'タイトルがEdit user | Ruby on Rails Tutorial Sample Appであること' do
        get edit_user_path(user)
        expect(response.body).to include full_title('Edit user')
      end

      it "別のユーザーの編集ページへアクセスした場合、リダイレクトされること" do
        get edit_user_path(other_user)
        expect(response).to redirect_to root_url
      end
    end
  end 

  describe "PATCH /users" do
    let(:user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:user, name: "archer", email: "testtest@test.com", admin: false)}

    it 'admin属性は更新できないこと' do
      # userはこの後adminユーザになるので違うユーザにしておく
      log_in other_user
      expect(other_user).to_not be_admin
 
      patch user_path(other_user), params: { user: { password: 'password',
                                               password_confirmation: 'password',
                                               admin: true } }
      user.reload
      expect(other_user).to_not be_admin
    end

    context "未ログイン時" do
      it "ログインページへリダイレクトされること" do
        patch user_path(user), params: { user: { name: @name,
                                        email: @email,
                                        password: '',
                                        password_confirmation: '' } }

        expect(response).to redirect_to login_path
      end
    end

    context "他ユーザーにpatchリクエストした場合" do
      it "リダイレクトされること" do
        log_in user
        patch user_path(other_user), params: { user: { name: other_user.name,
                                                      email: other_user.email,
                                                      password: '',
                                                      password_confirmation: '' } }

        expect(response).to redirect_to root_url
      end
    end

    context '有効な値の場合' do
      before do
        log_in user
        @name = 'Foo Bar'
        @email = 'foo@bar.com'
        patch user_path(user), params: { user: { name: @name,
                                                 email: @email,
                                                 password: '',
                                                 password_confirmation: '' } }
      end
    
      it '更新できること' do
        user.reload
        expect(user.name).to eq @name
        expect(user.email).to eq @email
      end
   
      it 'Users#showにリダイレクトすること' do
        expect(response).to redirect_to user
      end
   
      it 'flashが表示されていること' do
        expect(flash).to be_any
      end
    end

    context '無効な値の場合' do
      before do
        log_in user
        patch user_path(user), params: { user: { name: '',
                                                 email: 'foo@invlid',
                                                 password: 'foo',
                                                 password_confirmation: 'bar' } }
      end
  
      it '更新できないこと' do
        user.reload
        expect(user.name).to_not eq ''
        expect(user.email).to_not eq ''
        expect(user.password).to_not eq 'foo'
        expect(user.password_confirmation).to_not eq 'bar'
      end
  
      it '更新アクション後にeditのページが表示されていること' do
        expect(response.body).to include full_title('Edit user')
      end
  
      it 'The form contains 4 errors.と表示されていること' do
        expect(response.body).to include 'The form contains 4 errors.'
      end
    end
  end

  describe 'pagination' do
    let(:user) { FactoryBot.create(:user) }
    before do
      30.times do
        FactoryBot.create(:continuous_users)
      end
      log_in user
      get users_path
    end
   
    it 'div.paginationが存在すること' do
      expect(response.body).to include '<div role="navigation" aria-label="Pagination" class="pagination">'
    end
  
    it 'ユーザごとのリンクが存在すること' do
      User.paginate(page: 1).each do |user|
        expect(response.body).to include "<a href=\"#{user_path(user)}\">"
      end
    end
  end

  describe 'DELETE /users/{id}' do
    let!(:user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:user, name: "archer", email: "testtest@test.com", admin:false)}
   
    context '未ログインの場合' do
      it '削除できないこと' do
        expect {
          delete user_path(user)
        }.to_not change(User, :count)
      end
   
      it 'ログインページにリダイレクトすること' do
        delete user_path(user)
        expect(response).to redirect_to login_path
      end
    end
   
    context 'adminユーザでない場合' do
      it '削除できないこと' do
        log_in other_user
        expect {
          delete user_path(user)
        }.to_not change(User, :count)
      end
   
      it 'rootにリダイレクトすること' do
        log_in other_user
        delete user_path(user)
        expect(response).to redirect_to root_url
      end
    end
  end
end
