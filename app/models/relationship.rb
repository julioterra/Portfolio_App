class Relationship < ActiveRecord::Base
  attr_accessible :followed_id
  
  # set the relationship of the follower and followed
  # attributes to Users. If we were linking these attributes to classes 
  # with the same names then Rails would automatically make the links.
  # however, in this case we have to specify that both of the
  # attributes belong to the Users
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  
  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
