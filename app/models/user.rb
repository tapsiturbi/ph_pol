class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]


  # CarrierWave GEM
  mount_uploader :avatar, AvatarUploader

#   validates :email, presence: true
#   validates :username, presence: true, length: { minimum: 5 }
#   validates :first_name, presence: true
#   validates :last_name, presence: true

  #has_many :links, dependent: :destroy

  # -- acts_as_votable ------------
  acts_as_voter

  # -- Recommendable ------------
  #recommends :comments, :users

  #-- Scopes -----------------
  def get_votes_of_pol(politician_id)
    return self.get_voted(Comment).where(comments: {id: Career.with_comments_no_group.where(politician_id: politician_id).select("comments.id")}).select("comments.id, votes.vote_flag").collect {|c| [c.id, c.vote_flag]}
  end

  # lookup if FB user exists in database, and creates one if not
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    #puts "-- FB auth -----------------------"
    #puts auth

    unless user
      user = User.create(
              first_name: auth.extra.raw_info.first_name,
              last_name: auth.extra.raw_info.last_name,
              provider:auth.provider,
              uid:auth.uid,
              email:auth.info.email,
              password:Devise.friendly_token[0,20],
              remote_avatar_url: auth.info.image)
    end
    user
  end

end
