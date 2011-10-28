require 'spec_helper'

describe "Users" do

  describe "Account sign-up" do

    describe "failure" do

      it "should not make a new user with incomplete info" do
        lambda {
          visit signup_path
          fill_in "Name",           with: ""
          fill_in "Email",          with: ""
          fill_in "Password",       with: ""
          fill_in "Confirmation",   with: ""
          click_button
        
          # since integration tests are not limited to a specific controller we 
          # need to specify here both controller and action
          response.should render_template 'users/new'  
         
          # check if error message div tag with proper id exists. Below are two 
          # statements that ultimate check for the same thing                                             
          response.should have_selector "div", id:"error_explanation"
          response.should have_selector "div#error_explanation"
          }.should_not change(User, :count).by(1)
      end
    end

    describe "success" do
      it "should not make a new user with incomplete info" do
        lambda {
          visit signup_path
          fill_in :user_name,           with: "julio terra"
          fill_in :user_email,          with: "julio@example.com"
          fill_in "Password",       with: "example"
          fill_in "Confirmation",   with: "example"
          click_button
        
          # since integration tests are not limited to a specific controller we 
          # need to specify both controller and action
          response.should render_template 'users/show'  
         
          # check if page title includes the users name in the title. Use the assigns
          # method to access the @user instance variable from the users controller  
          response.should have_selector "title", content: assigns(:user).name
          }.should change(User, :count).by(1)
      end

    end

  end

  describe "User sessions" do
    describe "failure" do
      it "should not log-in users without email and password" do
        @user = User.new(:email => "", :password => "")
        integration_sign_in(@user)

        response.should render_template 'sessions/new'
        response.should have_selector "div.flash.error", content: "Invalid"
      end
    end

    describe "success" do
      it "should log-in users with email and password" do
        @user = Factory(:user)
        integration_sign_in(@user)
        
        controller.should be_signed_in
        click_link "Log out"
        controller.should_not be_signed_in
      end
    end

  end

end
