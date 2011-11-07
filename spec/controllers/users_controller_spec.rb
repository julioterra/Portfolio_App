require 'spec_helper'

describe UsersController do
  render_views

  before(:each) do
    @base_title = "Portfolios | "
  end


  describe "GET 'index' " do
      describe "for non-signed-in users" do
          it "should deny access" do
              get :index
              response.should redirect_to signin_path
              flash[:notice].should =~ /sign in/i
          end
      end

      describe "for signed-in users who are NOT admins" do
          before (:each) do
              @user = test_sign_in Factory :user
              second = Factory :user, email: "second@email.com"
              third = Factory :user, email: "third@email.com"
              @users = [@user, second, third]
              30.times do
                  @users << Factory(:user, email: Factory.next(:email))
              end
          end
          
          it "should be granted access" do
              get :index
              response.should be_success
          end
          it "should have the right title" do
              get :index
              response.should have_selector "title", content: "All users"
          end
          it "should have an element for each user" do
              get :index
              @users.each do |user|
                  response.should (have_selector "li", content: user.name)
              end
          end
          it "should not be able to delete other users" do
              get :index
              @users.each do |user|
                  response.should_not (have_selector "li", content: "delete")
              end
          end
          it "should paginate user" do
              get :index
              response.should have_selector "div.pagination"
              response.should have_selector "span.disabled", content: "Previous"
              response.should have_selector "a", href: "/users?page=2",
                                                 content: "2"
              response.should have_selector "a", href: "/users?page=2",
                                                 content: "Next"
          end
      end

      describe "for signed-in users who are ADMINS" do
          before (:each) do
              @user = test_sign_in Factory(:user, admin: true)
              second = Factory :user, email: "second@email.com"
              third = Factory :user, email: "third@email.com"
              @users = [@user, second, third]
              30.times do
                  @users << Factory(:user, email: Factory.next(:email))
              end
          end

          it "should BE able to delete other users" do
              get :index
              test_sign_in(@user)
              @users.each do |user|
                  response.should (have_selector "li", content: "delete")
              end
          end
      end

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
    it "should show the user's microposts" do
        @mp1 = Factory(:micropost, :user => @user, created_at: 1.day.ago)
        @mp2 = Factory(:micropost, :user => @user, created_at: 1.hour.ago)
        get :show, id: @user
        response.should have_selector("span.content", content: mp1.content)
        response.should have_selector("span.content", content: mp2.content)
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

    describe "FAIL scenarios" do
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

    describe "SUCCESS scenarios" do
      before(:each) do
        @attr = {name: "joe blow", email: "test@example.com", password: "example", password_confirmation: "example"}
      end
      it "should accept complete forms" do
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
      it "should leave the signed in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end

    end    

  end
  
  # ~~~~~~~~~~~~~~~~~~~
  # POST / CREATE TESTS
  describe "GET 'edit' " do
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end
    it "should be successful" do
      get :edit, :id => @user
      response.should be_success
    end
    it "should have right title" do
      get :edit, :id => @user
      response.should have_selector "title", :content => "edit"
    end
    it "should have a link to change profile picture (gravatar)" do
      get :edit, :id => @user
      gravatar_url = "http://gravatar.com/emails"
      response.should have_selector "a", :href => gravatar_url,
                                         :content => "change"
    end
  end
  
  
  # ~~~~~~~~~~~~~~~~~~~
  # POST / UPDATE TESTS
  describe "PUT 'update'" do
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    describe "FAIL scenarios" do
      before(:each) do
        @attr = {name: "", email: "", password: "", password_confirmation: ""}
      end
      it "should have the right title" do
        put :update, :id => @user,:user => @attr
        response.should have_selector "title", :content => "edit"
      end
      it "should not change size of database" do
        Proc.new do
          put :update, :id => @user,:user => @attr
        end.should_not change(User, :count)
      end
      it "should render the update page after failed submissions" do
        put :update, :id => @user,:user => @attr
        response.should render_template :edit
      end
      it "should render error message" do
        put :update, :id => @user,:user => @attr
        response.should have_selector "div", :id => "error_explanation"
      end
    end    

    describe "SUCCESS scenarios" do
      before(:each) do
        @attr = {name: "joe blow", email: "test@example.com", 
                 password: "example", password_confirmation: "example"}
      end

      it "should update data" do
        put :update, :id => @user,:user => @attr
        @user.reload
        @user.name.should == @attr[:name]
        @user.email.should == @attr[:email]
      end
      
      it "should take user to show page" do
        put :update, :id => @user,:user => @attr
        response.should redirect_to user_path(@user)
      end
      
      it "should render page with success message" do
        put :update, :id => @user,:user => @attr
        flash[:success].should =~ /updated/i
      end
      
      it "should leave the signed in" do
        put :update, :id => @user,:user => @attr
        controller.should be_signed_in
      end

    end    

  end
  
  
  # ~~~~~~~~~~~~~~~~~~~
  # POST / UPDATE TESTS
  describe "Authentication of edit/update pages" do
      before(:each) do
          @user = Factory(:user)
      end
      
      describe "for non-signed user" do
          it "should deny access to 'edit'" do
              get :edit, id: @user
              response.should redirect_to signin_path
          end
          it "should deny access to 'update'" do
              get :edit, id: @user, user: {}
              response.should redirect_to signin_path
          end
      end

      describe "for signed user" do
          before(:each) do
              wrong_user = Factory(:user, :email => "user@example.net")
              test_sign_in(wrong_user)
          end
          it "should require matching user for 'edit'" do
              get :edit, id: @user
              response.should redirect_to root_path
          end
          it "should require matching user for 'update'" do
              get :update, id: @user, user: {}
              response.should redirect_to root_path
          end
      end

  end
  
  # ~~~~~~~~~~~~~~~~~~~
  # DELETE / DESTROY TESTS
  describe "DELETE 'destroy'" do
    before(:each) do
      @user = Factory(:user)
    end

    describe "as a non-signed-in user" do
        it "should deny access" do
            delete :destroy, id: @user
            response.should redirect_to(signin_path)
        end
    end

    describe "as a signed-in non-admin user" do
      it "should deny access" do
          test_sign_in(@user)
          delete :destroy, id: @user
          response.should redirect_to(root_path)
      end      

      it "should not show delete links" do
          test_sign_in(@user)
          delete :destroy, id: @user
          response.should redirect_to(root_path)
      end      

    end

    describe "as a signed-in admin user" do
      before(:each) do
        admin = Factory(:user, email: "different@one.com", admin: true)
        test_sign_in(admin)
      end

      it "should destroy user" do
          lambda do
          delete :destroy, id: @user
          end.should change(User, :count).by(-1)
      end      

      it "should redirect to users page" do
          delete :destroy, id: @user
          response.should redirect_to(users_path)
      end      
      
    end

  end

  describe "micropost associations" do
      before(:each) do
          @attr = {name: "joe blow", email: "test@example.com", password: "example", password_confirmation: "example"}
          @user = User.create(@attr)
          @mp1 = Factory(:micropost, user: @user, created_at: 1.day.ago)
          @mp1 = Factory(:micropost, user: @user, created_at: 1.hour.ago)
      end
      
      describe "status feed" do
          it "should have a feed" do
              @user.should.respond_to(:feed)
          end
        
          it "should show all the messages created by the current user" do
              @user.feed.include?(@mp1).should be_true
              @user.feed.include?(@mp2).should be_true
          end
      
          it "should not show messages created by other users" do
            user2 = Factory(:user, email: Factory.next(:email))
            user2mp = Factory(:micropost, user: user2)
            @user.feed.include?(user2mp).should be_false            
            user2.feed.include?(@mp1).should be_false
          end
      end      
  end

end
