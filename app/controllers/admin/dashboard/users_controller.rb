class Admin::Dashboard::UsersController < Admin::DashboardController
  layout 'admin/dashboard/application.html.erb'

  before_action :admin_user
  before_action :set_user_model_name
  before_action :set_column_names_of_user_model

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
    @user.update(user_params)
  end

  def new
    if User.all.present?
      users = User.all
      @new_user_id = users.last.id+1
    else
      @new_user_id = 1
    end

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
      redirect_to admin_dashboard_users_path
    rescue ActiveRecord::RecordInvalid => e
      @user = e.record
      p e.message
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.reactions
    @user.destroy
    redirect_to admin_dashboard_users_path
  end



  private
  
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


  def admin_user
    redirect_to(root_path) if  current_user.nil? || !current_user.admin?
  end

end
