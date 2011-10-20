require 'spec_helper'

describe UsersController do
  render_views

  before(:each) do
    @base_title = "Portfolios | "
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
    it "should have a title" do
      get 'new'
      response.should have_selector "title", :content => @base_title + "Sign Up"
    end
  end

end
