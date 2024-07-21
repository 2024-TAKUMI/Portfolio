module Public
  class PostsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_post, only: [:show, :edit, :update, :destroy]
    before_action :correct_user, only: [:edit, :update, :destroy]
    before_action :set_genres, only: [:new, :edit, :create, :update]

    def index
      @posts = Post.all
    end

    def show
    end

    def new
      @post = Post.new
    end

    def create
      @post = current_user.posts.build(post_params)
      if @post.save
        flash[:notice] = "投稿が作成されました。"
        redirect_to @post
      else
        flash.now[:alert] = "投稿に失敗しました。"
        render :new
      end
    end

    def edit
    end

    def update
      if @post.update(post_params)
        flash[:notice] = "投稿が更新されました。"
        redirect_to @post
      else
        flash.now[:alert] = "更新に失敗しました。"
        render :edit
      end
    end

    def destroy
      @post.destroy
      flash[:notice] = "投稿が削除されました。"
      redirect_to posts_path
    end

    private

    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :body, :genre_id, :subgenre_id, :image)
    end

    def correct_user
      unless @post.user == current_user
        flash[:alert] = "他のユーザーの投稿は編集・削除できません。"
        redirect_to posts_path
      end
    end

    def set_genres
      @parent_genres = Genre.where(parent_id: nil)
      @subgenres = Genre.where.not(parent_id: nil)
    end
  end
end
