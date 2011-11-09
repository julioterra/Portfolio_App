require 'spec_helper'

describe User do
  
  before (:each) do
    @attr = {name: "Julio Terra", 
             email: "juliot@jt.com",
             password: "testing",
             password_confirmation: "testing"}
    
  end
  
  it "should create a new record given valid information" do
    User.create!(@attr)
  end

    describe "password validations: " do

        before (:each) do
          email = "shufflenamehere".split('').shuffle.join + "@gmail.com"
          @attr.merge(email: email)
          @user = User.create!(@attr)
        end
      
        it "should require a password" do
            User.new(@attr.merge(password:"", password_confirmation: ""))
            should_not be_valid
        end
        
        it "should require password match confirmation" do
            User.new(@attr.merge(password_confirmation: "invalid"))
            should_not be_valid
        end
        
        it "should reject short passwords" do
            short = 'a' * 5
            User.new(@attr.merge(password: short, password_confirmation: short ))
            should_not be_valid
        end

        it "should reject long passwords" do
            long = 'a' * 41
            User.new(@attr.merge(password: long, password_confirmation: long ))
            should_not be_valid
        end
        
        it "encrypted password should not be blank" do
            @user.encrypted_password.should_not be_blank
        end
        
        it "should have an encrypted password attribute" do
            @user.should respond_to(:encrypted_password)
        end

        describe "password encryption method functions: " do        
          
            it "should be true if passwords match" do
                @user.has_password?(@attr[:password]).should be_true
            end
            
            it "should be false if passwords don't match" do
                @user.has_password?("invalid").should be_false
            end

            describe "authenticate method functions: " do        
              
                it "should not work if the email is not valid" do
                    wrong_password_user = User.authenticate("invalid password", @attr[:password])
                    wrong_password_user.should be_nil
                end

                it "should not work if the email and password combination is not valid " do
                    wrong_password_user = User.authenticate(@attr[:email], "invalid_pass")
                    wrong_password_user.should be_nil
                end

                it "should work if the email and password are correct" do
                  wrong_password_user = User.authenticate(@attr[:email], @attr[:password])
                  wrong_password_user.should == @user
                end

            end
        end        
    end



    describe "name validations " do
        it "should require a name" do
          no_name_user = User.new(@attr.merge(name:""))
          no_name_user.should_not be_valid
        end

        it "should reject names longer than 50 characters" do
          long_name = "l" * 51
          no_name_user = User.new(@attr.merge(name:long_name))
          no_name_user.should_not be_valid
        end
    end
    


    describe "email validations " do
        it "should require an email" do
          no_name_user = User.new(@attr.merge(email:""))
          no_name_user.should_not be_valid
        end

        it "should accept valid emails" do
          address = %w[foo@boo.org fooboo.boo@loo.go.bo FOOBOO@lootoo.doo]
          address.each do |cur_e|
            no_name_user = User.new(@attr.merge(email:cur_e))
            no_name_user.should be_valid
          end
        end

        it "should reject invalid emails" do
          address = %w[foo@boo.org. fooboo.boo@loo gooboo.doo jooodooo@]
          address.each do |cur_e|
            no_name_user = User.new(@attr.merge(email:cur_e))
            no_name_user.should_not be_valid
          end
        end

        it "should not accept duplicate emails" do
          user_upcase = @attr.merge(email: @attr[:email].upcase)
          User.create!(user_upcase)                       #create user with an email to test against
          user_with_same_email = User.new(user_upcase)    #create second user with same email
          user_with_same_email.should_not be_valid        #second user should not be valid
        end
    end
    
    describe "admin attribute" do
      before(:each) do
          @user = User.create!(@attr)
      end
      
      it "should respond to admin" do
        @user.should respond_to(:admin)
      end

      it "should not be an admin by default" do
        @user.should_not be_admin
      end

      it "should not convertible to admin" do
        @user.toggle!(:admin)
        @user.should be_admin
      end
      
    end
   
    describe "micropost association" do
      before(:each) do
          @user = User.create(@attr)
          @mp1 = Factory(:micropost, :user => @user, created_at: 1.day.ago)
          @mp2 = Factory(:micropost, :user => @user, created_at: 1.hour.ago)
      end
      
      it "should have a micropost attribute" do
          @user.should respond_to(:microposts)
      end

      it "should have the microposts in the right order" do
          @user.microposts.should == [@mp2, @mp1]
      end

      it "should destroy microposts associated to users" do
          @user.destroy
          [@mp2, @mp1].each do |mp|
              Micropost.find_by_id(mp.id).should be_nil
          end
      end
      
      describe "micropost feeds" do
        it "should have a feed" do
          @user.should respond_to :feed
        end
        it "should include the user's microposts" do
          @user.feed.should include(@mp1)
          @user.feed.should include(@mp2)
        end
        it "should not include a different user's microposts" do
          mp3 = Factory(:micropost,
                        user: Factory(:user, email: Factory.next(:email)))
          @user.feed.should_not include(mp3)
        end
        it "should include the micropost of followed users" do
          other_user = Factory(:user, email: Factory.next(:email))
          mp3 = Factory(:micropost, user: other_user)
          @user.follow!(other_user)
          @user.feed.should include(mp3)
        end
      end
   end   

   describe "relationship model" do
      before (:each) do
        @user = User.create(@attr)
        @followed = Factory(:user)
      end
      it "should have a relationship method" do
        @user.should respond_to(:relationships)
      end     
      it "should have a following method" do
        @user.should respond_to(:following)
      end
      it "should have a following? method" do
        @user.should respond_to(:following?)
      end
      it "should have a follow! method" do
        @user.should respond_to(:follow!)
      end
      it "should follow another user when requested" do
        @user.follow!(@followed)
        @user.should be_following(@followed)
      end
      it "should include followed user in following array" do
        @user.follow!(@followed)
        @user.following.should include(@followed)
      end
      it "should have a unfollow! method" do
        @user.should respond_to(:unfollow!)
      end
      it "should stop following a user when requested" do
        @user.follow!(@followed)
        @user.unfollow!(@followed)
        @user.should_not be_following(@followed)
      end
      it "should have a reverse_relationships method" do
        @user.should respond_to(:reverse_relationships)
      end
      it "should have a followers method" do
        @user.should respond_to(:followers)
      end
      it "should include the follower in the followers array" do
        @followed.follow!(@user)
        @user.followers.should include(@followed)
      end
      
   end

    
end
