class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :role_ids, :as => :admin
  attr_accessible :role_ids, :as => :jefe
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :jefe, :empleados

  belongs_to  :jefe, :class_name => "User", :foreign_key => "jefe_id"
  has_many  :empleados, :through => :users


end
