class BooksController < ApplicationController
before_action :authenticate_user! #ログインしていなければログインページへ戻る
  def create # 投稿したTitleとbodyを保存する
    @book = Book.new(book_params)  # 空のモデルを作って投稿データをデータベースに保存
    @books =Book.all
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book.id), notice: 'You have created book successfully.'
    else
      render :index #投稿がうまくいかなかった場合に
    end
  end

  def index #投稿されたデータが一覧ページで表示される
    @book = Book.new
    @users = User.all
    @books = Book.all #タイムライン上に表示する投稿データを取得
  end

  def show #詳細ページ
    @new_book = Book.new
    @book = Book.find(params[:id])
    @books = Book.all
    @user = @book.user
  end

  def edit #編集ページ
    @book = Book.find(params[:id]) # 投稿済みのデータを編集
    if @book.user_id != current_user.id
      redirect_to books_path
    end
  end

  def update # 編集した投稿を保存する
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book.id), notice: 'You have updated book successfully.'
    else
      render :edit
    end
  end

  def destroy #投稿データ削除
    @book = Book.find(params[:id]) # データ（レコード）を1件取得
    @book.destroy # データ（レコード）を削除
    redirect_to books_path # 投稿一覧画面へリダイレクト
  end


  private #投稿データを保存(create)するのにストロングパラメーターが必要

  def book_params
    params.require(:book).permit(:title, :body, :user_id)
  end

end
