class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    
      @users = User.all
    
   # authorize! :index, @user, :message => 'Not authorized to see users.'
  end

  def show
    @user = User.find(params[:id])
    authorize! :show, @user, :message => 'Not authorized.'
  end
  
  def update
    @user = User.find(params[:id])   
    #binding.pry
    authorize! :update, @user, :message => 'Not authorized.'

    if @user.update_attributes(params[:user])
      @user.save
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end
    
#  def destroy
#    authorize! :destroy, @user, :message => 'Not authorized as an administrator.'
#    user = User.find(params[:id])
#    unless user == current_user
#      user.destroy
#      redirect_to users_path, :notice => "User deleted."
#    else
#      redirect_to users_path, :notice => "Can't delete yourself."
#    end
#  end

  def createEmployee
    @user = User.new(params[:post])
    @user.jefe = current_user
    authorize! :createEmployee, @user, :message => 'Not authorized to create users.'
    if @user.save
      redirect_to users_path, :notice => "User created."
    else 
      redirect_to users_path, :notice => "Unable to create user."
    end
  end

end
