require 'rails_helper'

RSpec.describe "SiteLayouts", type: :request do
  before(:each){
    visit root_path
  }

  describe "GET /site_layouts", type: :feature do

    it "click on the 'Home' link opens the home page" do
      click_link 'Home'
      expect(page).to have_title(full_title('Home'))
    end

    it "click on the 'About' link opens the about page" do
      click_link 'About'
      expect(page).to have_title(full_title('About'))
    end

    it "click on the 'Contact' link opens the contact page" do
      click_link 'Contact'
      expect(page).to have_title(full_title('Contact'))
    end

    it "click on the 'Help' link opens the help page" do
      click_link 'Help'
      expect(page).to have_title(full_title('Help'))
    end

    it "click on the 'Signup' link opens the signup page" do
      click_link 'Sign up now!'
      expect(page).to have_title(full_title('Signup'))
    end

    it "click on the 'Log in' link opens the login page" do
      click_link 'Log in'
      expect(page).to have_title(full_title('Login'))
    end

  end
end
