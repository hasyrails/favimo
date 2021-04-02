class DemoAdmin::Dashboard::UsersController < DemoAdmin::DashboardController
  layout 'demo_admin/dashboard/application.html.erb'

  before_action :demo_admin_user
  before_action :set_user_model_name
  before_action :set_column_names_of_user_model
  before_action :set_update_attributes_names_of_user_model

  def index
    @users = User.all

    @users = User.page(params[:page]).per(5)

  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update!(user_params)
      redirect_to demo_admin_dashboard_user_path(@user), notice: "#{@user.model_name.name}モデルレコード( id = #{@user.id} )の情報を更新しました"
    else 
      render :edit, alert: "#{@user.model_name.name}モデルレコード( id = #{@user.id} )の情報の更新ができませんでした"
    end
  end

  def new
    # if User.all.present?
    #   users = User.all
    #   @new_user_id = users.last.id+1
    # else
    #   @new_user_id = 1
    # end

    @user = User.new

    column_names = []
    @columns.each do |column|
      column_names << column.name
    end
    
    column_names.reject! do |column_name| 
      column_name == "id" ||
      column_name == "updated_at" || column_name == "created_at"
    end

    @column_names_for_new_user = column_names
  end

  def create
    begin
      @user = User.new(user_params)
      @user.save!
      redirect_to demo_admin_dashboard_users_path

      # ユーザー作成はアプリ内のアカウント作成画面で行うためフラッシュメッセージの実装不要

      # if @user.save!
      #   flash[:notice] = "#{@user.model_name.name}モデルレコードを作成しました"
      #   redirect_to demo_admin_dashboard_users_path
      # else
      #   flash.now[:alert] = "#{@user.model_name.name}モデルレコードを作成できませんでした"
      #   render new_demo_admin_dashboard_user_path
      # end

    rescue ActiveRecord::RecordInvalid => e
      @user = e.record
      p e.message
    end
  end
  
  def destroy
    begin
      @user = User.find_by(id: params[:id])
      @user.destroy
      redirect_to demo_admin_dashboard_users_path, notice: "#{@user.model_name.name}モデルレコード( id = #{@user.id} )を削除しました"
    rescue ActiveRecord::InvalidForeignKey => e
      p e.message
    end
  end
    
    
    
  private

  def set_update_attributes_names_of_user_model
    @columns = ActiveRecord::Base.connection.columns(:users)
    
    column_names = []
    @columns.each do |column|
      column_names << column.name
    end
    column_names.shift
    column_names.pop
    @update_attributes = column_names

  end
  
  def set_user_model_name
    @model_name = User.model_name.name
  end
  
  def set_column_names_of_user_model
    @columns = ActiveRecord::Base.connection.columns(:users)
    
    column_names = []
    @columns.each do |column|
      column_names << column.name
    end
    @column_names = column_names

  end
  
  def user_params
    params.require(:user).permit(@column_names)
  end


  def demo_admin_user
    redirect_to(root_path) if  current_user.nil? || !current_user.demo_admin?
  end

end
