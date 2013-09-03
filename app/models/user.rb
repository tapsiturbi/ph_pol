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

  # -- acts_as_votable ------------
  acts_as_voter

  # -- Recommendable ------------
  #recommends :comments, :users

  #-- Scopes -----------------
  def get_votes_of_pol(politician_id)
    return self.get_voted(Comment).where(comments: {id: Career.with_comments_no_group.where(politician_id: politician_id).select("comments.id")}).select("comments.id, votes.vote_flag").collect {|c| [c.id, c.vote_flag]}
  end
end
