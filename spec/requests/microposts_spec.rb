require 'spec_helper'

describe "Microposts" do

  before (:each) do
      user = Factory(:user)
      visit signin_path
      fill_in :email,     with: user.email
      fill_in :password,  with: user.password
      click_button
  end

  describe ": creation " do
    describe ": failure " do
      it ": has no content and should not create new micropost" do
        lambda do
          visit root_path
          fill_in :micropost_content, with: ""
          click_button
          response.should render_template('pages/home')
          response.should have_selector('div#error_explanation')
        end.should_not change(Micropost, :count)
      end
    end
    describe ": success " do
      it ": has content and should create new micropost" do
        content =  "this should work"
        lambda do
          visit root_path
          fill_in :micropost_content, with: content
          click_button
          response.should have_selector('span.content', content: content)
        end.should change(Micropost, :count).by(1)
      end
    end
  end
end
