require 'spec_helper'

describe MicropostsController do
  render_views
  
  describe "access control" do
    
    it "should deny access to 'create'" do
        post :create
        response.should redirect_to(signin_path)
    end

    it "should deny access to 'destroy'" do
        delete :destroy, id: 1
        response.should redirect_to(signin_path)
    end
    
  end
  
  describe "POST 'create'" do 

    describe "failure scenarios" do
        # create an @user instance object with a Factory user
        # - sign in with another Factory user's information
        # - create a micropost with content that will be rejected 
        before(:each) do
            @user = Factory(:user)
            test_sign_in(Factory(:user, email: Factory.next(:email)))
            @attr = {content: " "}
        end     

        it "should not create a micropost" do
            lambda do 
              post:create, :micropost => @attr
            end.should_not change(Micropost, :count)
        end     

        it "should render the home page" do
            post:create, :micropost => @attr
            response.should render_template('pages/home')
        end     

    end


    describe "success scenarios" do
        # create an @user instance object and sign it in
        # - create a micropost with content that will be accepted 
        before(:each) do
            @user = test_sign_in(Factory(:user))
            @attr = {content: "sample content"}
        end     
        
        it "should create a micropost" do
            lambda do 
              post:create, :micropost => @attr
            end.should change(Micropost, :count).by(1)
        end     

        it "should send user back to their home page" do
            post:create, :micropost => @attr
            response.should redirect_to(root_path)
        end     

        it "should have a flash message" do
            post:create, :micropost => @attr
            flash[:success].should =~ /micropost created/i
        end     

    end
  end
  
  describe "DELETE 'destroy'" do
    describe "non-authorized user" do
        # create an @user instance object with a Factory user
        # - sign in with another Factory user's information
        # - create @micropost instance object with a micropost created by the Factory 
        before(:each) do
            @user = Factory(:user)
            test_sign_in(Factory(:user, email: Factory.next(:email)))
            @micropost = Factory(:micropost, user: @user)
        end     

        it "should fail" do
            delete :destroy, id: @micropost
            response.should redirect_to(root_path)
        end
    end

    describe "authorized user" do
      # create an @user instance object and sign it in
      # - create @micropost instance object with a micropost created by the Factory 
      before(:each) do
          @user = test_sign_in(Factory(:user))
          @micropost = Factory(:micropost, user: @user)
      end     
      it "should fail" do
        lambda do
          delete :destroy, id: @micropost
        end.should change(Micropost, :count).by(-1)
      end
    end
    
  end
  
end
