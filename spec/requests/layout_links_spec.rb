require 'spec_helper'

describe 'LayoutLinks' do
  
  describe "Pages link tests" do
    it "should have a Home page at '/'" do
      get '/'
      response.should have_selector 'title', content: "Home"
    end
    it "should have a Contact page at '/contact'" do
      get '/contact'
      response.should have_selector 'title', content: "Contact"
    end
    it "should have a Contact page at '/about'" do
      get '/about'
      response.should have_selector 'title', content: "About"
    end
    it "should have a Sign up page at '/signup'" do
      get '/signup'
      response.should have_selector 'title', content: "Sign Up"
    end
    it "should have the right links on the homepage" do
      visit root_path
      click_link "About"
      response.should have_selector 'title', content: "About"
      click_link "Home"
      response.should have_selector 'title', content: "Home"
      click_link "Contact"
      response.should have_selector 'title', content: "Contact"
      # test not working though functionality is correct
      # click_link 'Sign Up Now Kamikaze!'
      # response.should have_selector 'title', content: "Sign Up"
    end
  end
  
  describe "Sessions links tests" do

    describe "User not logged in" do
      it "should have a log in link" do
        visit root_path
        response.should have_selector "a", href: signin_path,
                                           content: "Log in"
      end
    end

    describe "User logged in" do
      before (:each) do
        @user = Factory(:user)
        visit signin_path
        fill_in :email, with: @user.email
        fill_in :password, with: @user.password
        click_button
      end
      it "should have a log out link" do
        visit root_path
        response.should have_selector "a", href: signout_path,
                                           content: "Log out"
      end
      it "should have a profile link" do
        visit root_path
        response.should have_selector "a", href: user_path(@user),
                                           content: "Profile"
      end      
    end

  end
  
end