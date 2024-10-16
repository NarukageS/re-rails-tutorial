require 'rails_helper'

RSpec.describe 'サイト動線', type: :system do
  it "layout links" do
    visit root_path
    expect(page).to have_link('', href: root_path, count: 2)
    expect(page).to have_link('', href: help_path)
    expect(page).to have_link('', href: about_path)
    expect(page).to have_link('', href: contact_path)
    expect(page).to have_link('', href: signup_path)
    visit contact_path
    expect(page).to have_title(full_title("Contact"))

    visit signup_path
    expect(page).to have_title(full_title("Sign up"))
  end
end