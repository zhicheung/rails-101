class PostsController < ApplicationController
  before_action :authenticate_user! , only: [:new, :create, :edit, :update, :destory]

  def new
    @group = Group.find(params[:group_id])
    @post = Post.new
  end

  def create
    @group = Group.find(params[:group_id])
    @post = Post.new(post_params)
    @post.group = @group
    @post.user = current_user

    if @post.save
      redirect_to group_path(@group)
    else
      render :new
    end
  end

  def edit
    @group = Group.find(params[:group_id])
    @post = Post.find(params[:id])
    @post.group = @group
  end

  def update
    @group = Group.find(params[:group_id])
    @post = Post.find(params[:id])
    @post.group = @group
    @post.user = current_user

    if @post.update(post_params)
      redirect_to group_path, notice: "编辑成功"
    else
      render :edit
    end
  end

  def destroy
    @group = Group.find(params[:group_id])
    @post = Post.find(params[:id])
    @post.group = @group
    @post.destroy
    flash[:alert] = "Post deleted"
    redirect_to account_posts_path
  end

  private

  def find_post_and_check_permission
    @post = Post.find(params[:id])
  if current_user != @post.user
    redirect_to root_path, alert: "You have no permission"
  end
end

  def post_params
    params.require(:post).permit(:content)
  end

end
