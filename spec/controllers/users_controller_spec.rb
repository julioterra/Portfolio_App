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

  # ~~~~~~~~~~~~~~~~~~~
  # GET / NEW TESTS
  describe "GET 'new' " do
    it "should be successful" do
      get :new
      response.should be_success
    end
    it "should have a title" do
      get :new
      response.should have_selector "title", :content => @base_title + "Sign Up"
    end
    
    describe "test form elements" do
      it "should have a user name field" do
        get :new
        response.should have_selector "input", :name => "user[name]", type: "text"
      end
      it "should have a user email field" do
        get :new
        response.should have_selector "input", :name => "user[email]", type: "text"
      end
      it "should have a user password field" do
        get :new
        response.should have_selector "input", :name => "user[password]", type: "password"
      end
      it "should have a user password confirmation field" do
        get :new
        response.should have_selector "input", :name => "user[password_confirmation]", type: "password"
      end
    end

  end
  
  # ~~~~~~~~~~~~~~~~~~~
  # POST / CREATE TESTS
  describe "POST 'create'" do

    describe "failure scenarios" do
      before(:each) do
        @attr = {name: "", email: "", password: "", password_confirmation: ""}
      end
      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector "title", :content => "Sign Up"
      end
      it "should not accepte incomplete forms" do
        Proc.new do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end
      it "should render the new page after submission" do
        post :create, :user => @attr
        response.should render_template :new
      end
      it "should render error message" do
        post :create, :user => @attr
        response.should have_selector "div", :id => "error_explanation"
      end
    end    

    describe "success scenarios" do
      before(:each) do
        @attr = {name: "joe blow", email: "test@example.com", password: "example", password_confirmation: "example"}
      end
      it "should accept incomplete forms" do
        Proc.new do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end
      it "should take user to correct path" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end
      it "should render page with success message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to the portfolio app/i
      end
    end    

  end

end
