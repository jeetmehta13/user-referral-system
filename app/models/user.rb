class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :referrals, :foreign_key => :referrer_id
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
