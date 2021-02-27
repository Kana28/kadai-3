class UsersController < ApplicationController
before_action :authenticate_user! #ログインしていなければログインページへ戻る

  def index
    @users = User.all
    @book = Book.new
    @books = Book.all
  end

  def show
    @user = User.find(params[:id]) # ユーザーのデータを１件取得しインスタンス変数に渡す
    @users = User.all
    @books = @user.books.reverse_order # 1:N＝＠user:books
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
    @users = User.all
    if current_user.id != @user.id
      redirect_to user_path(current_user.id)
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice: 'You have updated user successfully.'
    else
      render :edit
    end
  end

  private #投稿データを保存(create.update)するのにストロングパラメーターが必要

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end
end
