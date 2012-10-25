require 'spec_helper'

describe UsersController do

  describe "GET 'show'" do

    before (:each) do
      @user = FactoryGirl.create(:user)
      sign_in @user
    end

    it "should be successful" do
      get :show, :id => @user.id
      response.should be_success
    end
    
    it "should find the right user" do
      get :show, :id => @user.id
      assigns(:user).should == @user
    end
  end

  describe "Update" do

    context "When user rol is :admin"
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


    describe "Destroy" do
      describe "When user rol is :admin" do

        it "can delete users" do
          pending
          delete :destroy, :id => @user.id
          response.should_not be_success
          pending "Hay que ver que pasa aqui, si es por el jscript o que?"
        end
      end

      it "can add regular users in his company" do
        pending
        @attr = { :name => "username", :email => "mail@example.com", :password => "changeit", :password_confirmation => "changeit" }
        post :createEmployee, :post => @attr
        user2 = User.find_by_email("mail@example.com") 
        user2.should_not be_nil
        user2.jefe_id.should == @jefe.id
      end

      it "can delete regular users of his company" do 
        pending
      end

    end

end
