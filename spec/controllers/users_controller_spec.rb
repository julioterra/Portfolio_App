require 'spec_helper'

describe UsersController do
  render_views

  before(:each) do
    @base_title = "Portfolios | "
  end

  describe "GET 'show' " do
    before(:each) do
      @user_new = Factory(:user)
    end
    it "should have user name in title" do
      get :show, :id => @user_new
      response.should have_selector "title", :content => @user_new.name
    end
    it "should have user name in heading" do
      get :show, :id => @user_new
      response.should have_selector "h1", :content => @user_new.name
    end
    it "should have a profile picture" do
      get :show, :id => @user_new
      response.should have_selector "h1>img", :class => "gravatar"
    end
    it "should load with user info" do
      get :show, :id => @user_new
      response.should be_success
    end
    it "should feature right user (with factory)" do
      get :show, :id => @user_new
      assigns(:user).should == @user_new       
    end
  end


  describe "GET 'new' " do
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
