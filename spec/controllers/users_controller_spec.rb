require 'spec_helper'

describe UsersController do

  describe "GET 'show'" do
    describe "When user rol is :admin" do

      before (:each) do
        @admin = FactoryGirl.create(:user)
        @admin.add_role :admin
        sign_in @admin
      end

      it "should be successful to see himself" do
        get :show, :id => @admin.id
        response.should be_success
      end
    
      it "should find the right user" do
        get :show, :id => @admin.id
        assigns(:user).should == @admin
      end
    end
  
    describe "When user rol is :jefe" do

      before (:each) do
        @jefe = FactoryGirl.create(:user)
        @jefe.add_role :jefe
        sign_in @jefe
      end

      it "should be successful to see himself" do
        get :show, :id => @jefe.id
        response.should be_success
      end


      it "should be successful to see an employee" do
        user = FactoryGirl.create(:user)
        user.jefe = @jefe
        user.save
        get :show, :id => user.id
        response.should be_success
      end

      it "should't be successful to see not an employee" do
        user = FactoryGirl.create(:user)
        get :show, :id =>   user.id
        response.should_not be_success
      end

    
      it "should find the right user" do
        get :show, :id => @jefe.id
        assigns(:user).should == @jefe
      end


    end
    
    describe "When user rol is :user" do

      before (:each) do
        @user = FactoryGirl.create(:user)
        @user.add_role :user
        sign_in @user
      end

      it "should be successful to see himself" do
        get :show, :id => @user.id
        response.should be_success
      end
    
      it "should find the right user" do
        get :show, :id => @user.id
        assigns(:user).should == @user
      end

      it "should't be successful to see another user" do
        user2 = FactoryGirl.create(:user)
        get :show, :id =>   user2.id
        response.should_not be_success
      end

    end
  end

  describe "PUT Update" do

    describe "When user rol is :admin" do
      before (:each) do
        Role.create([
          { :name => 'admin' }, 
          { :name => 'jefe' }, 
          { :name => 'user' }
          ], :without_protection => true)

        @admin = FactoryGirl.create(:user)
        @admin.add_role :admin
        @user = FactoryGirl.create(:user)
        @user.add_role :user
        sign_in @admin
      end
      
      it "can change role to users" do
        put :update, :id=> @user.id, :user => {:role_ids => '2'}
        @user.has_role?(:jefe).should be_true
      end

      it "can change role to users" do
        put :update, :id => @user.id, :user => {:role_ids => '2'} 
        @user.has_role?(:user).should be_false
      end      
    end


    describe "When user rol is :jefe" do
      before (:each) do
        Role.create([
          { :name => 'admin' }, 
          { :name => 'jefe' }, 
          { :name => 'user' }
          ], :without_protection => true)

        @jefe = FactoryGirl.create(:user)
        @jefe.add_role :jefe
        sign_in @jefe
      end
 
      it "can change role to jefe to employees " do
        @user = FactoryGirl.create(:user)
        @user.add_role :user
        @user.jefe = @jefe
        @user.save
        put :update, :id=> @user.id, :user => {:role_ids => '2'}
        @user.has_role?(:jefe).should be_true
      end

      it "can't change role if not employee" do
        @user = FactoryGirl.create(:user)
        @user.add_role :user
        @user.save
        put :update, :id=> @user.id, :user => {:role_ids => '2'}
        @user.has_role?(:jefe_id).should_not be_true
      end   
    end

    describe "When user rol is :user" do
      before (:each) do
        Role.create([
          { :name => 'admin' }, 
          { :name => 'jefe' }, 
          { :name => 'user' }
          ], :without_protection => true)

        @user = FactoryGirl.create(:user)
        @user.add_role :user
        sign_in @user
      end     

      it "can't change his role" do
        put :update, :id=> @user.id, :user => {:role_ids => '2'}
        @user.has_role?(:jefe).should be_false
      end

      it "can't change role of anybody" do
        @user2 = FactoryGirl.create(:user)
        @user2.add_role :user
        put :update, :id=> @user.id, :user => {:role_ids => '2'}
        @user2.has_role?(:jefe).should be_false
      end

    end
  end

  describe "POST createEmployee" do
    
    context "When user rol is :jefe" do

      before (:each) do
        Role.create([
          { :name => 'admin' }, 
          { :name => 'jefe' }, 
          { :name => 'user' }
          ], :without_protection => true)

        @jefe = FactoryGirl.create(:user)
        @jefe.add_role :jefe
        sign_in @jefe
      end

      it "can add regular users. He will be the jefe" do
        @attr = { :name => "username", :email => "mail@example.com", :password => "changeit", :password_confirmation => "changeit" }
        post :createEmployee, :post => @attr
        user2 = User.find_by_email("mail@example.com") 
        user2.should_not be_nil
        user2.jefe.should == @jefe
      end
    end

    context "When user rol is :user" do
      before (:each) do
        Role.create([
          { :name => 'admin' }, 
          { :name => 'jefe' }, 
          { :name => 'user' }
          ], :without_protection => true)

        @user = FactoryGirl.create(:user)
        @user.add_role :user
        sign_in @user
      end

      it "can't add regular users." do
        @attr = { :name => "username", :email => "correo@example.com", :password => "changeit", :password_confirmation => "changeit" }
        post :createEmployee, :post => @attr
        user2 = User.find_by_email("correo@example.com") 
        user2.should be_nil
      end
    end

  end

  describe "Destroy" do
    pending
  end

end