class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
#   validates :email, presence: true
#   validates :username, presence: true, length: { minimum: 5 }
#   validates :first_name, presence: true
#   validates :last_name, presence: true

  #has_many :links, dependent: :destroy
  
end