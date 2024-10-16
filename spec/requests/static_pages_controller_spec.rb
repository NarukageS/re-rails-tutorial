require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "リクエストが成功する" do
    before do
      @base_title = "Ruby on Rails Tutorial Sample App"
    end

    it "GET /" do
      get root_path
      expect(response).to be_successful
      expect(response.body).to include("#{@base_title}")
    end

    it "GET /help" do
      get help_path
      expect(response).to be_successful
      expect(response.body).to include("Help | #{@base_title}")
    end

    it "GET /about" do
      get about_path
      expect(response).to be_successful
      expect(response.body).to include("About | #{@base_title}")
    end

    it "GET /contact" do
      get contact_path
      expect(response).to be_successful
      expect(response.body).to include("Contact | #{@base_title}")
    end
  end
end

