require 'spec_helper'

describe 'Friendly Forwarding functioning' do
  
    it "should forward the user to requested page after sign-in" do
        user = Factory :user
        visit edit_user_path user
        fill_in :email,     :with => user.email
        fill_in :password,  :with => user.password
        click_button
        response.should render_template 'users/edit'
    end
  
end