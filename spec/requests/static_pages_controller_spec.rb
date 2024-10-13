require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "リクエストが成功する" do
    it "GET /home" do
      get static_pages_home_path
      expect(response).to be_successful
    end

    it "GET /help" do
      get static_pages_help_path
      expect(response).to be_successful
    end

    it "GET /about" do
      get static_pages_about_path
      expect(response).to be_successful
    end
  end
end