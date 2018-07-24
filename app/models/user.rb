class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  acts_as_universal_and_determines_account
  has_one :member, :dependent => :destroy
  has_many :products
  seems_rateable_rater
  
  def is_admin?
    is_admin
  end
  
  def self.find_by_email(email)
    where("email = :email", { email: email })
  end
end
