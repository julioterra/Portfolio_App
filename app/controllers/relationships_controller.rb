class RelationshipsController < ApplicationController
  before_filter :authenticate
  
  # respond_to :html, :js

def create
  @user = User.find(params[:relationship][:followed_id])
  return if current_user.relationships.find_by_followed_id(@user.id)
  current_user.follow!(@user)
  respond_to do |format|
    format.html { redirect_to @user }
    format.js {render 'relationships/create'}
  end
  # respond_with @user
end

def destroy
  @user = Relationship.find(params[:id]).followed
  current_user.unfollow!(@user)
  respond_to do |format|
    format.html { redirect_to @user }
    format.js {render 'relationships/destroy'}
  end
  # respond_with @user
end

end