class DemoAdmin::Dashboard::FavoritesController < DemoAdmin::DashboardController
  layout 'demo_admin/dashboard/application.html.erb'

  before_action :set_favorite_model_name
  before_action :set_column_names_of_favorite_model

  def index
    @favorites = Favorite.page(params[:page]).per(5)
  end

  def show
    @favorite = Favorite.find(params[:id])
  end

  def edit
    @favorite = Favorite.find(params[:id])
  end

  def update
    @favorite = Favorite.find(params[:id])
    begin
      @favorite.update(favorite_params)
      flash[:notice] = "#{@favorite.model_name.name}モデルレコードを更新しました<br>id = #{@favorite.id}"
      redirect_to demo_admin_dashboard_favorite_path(@favorite)
    rescue ArgumentError, ActiveRecord::NotNullViolation => e
      flash[:alert] = "#{@favorite.model_name.name}モデルレコードを更新できませんでした"
      redirect_to edit_demo_admin_dashboard_favorite_path(@favorite)
    end
  end

  def new
    if Favorite.all.present?
      favorites = Favorite.all
      @new_favorite_id = favorites.last.id+1
    else
      @new_favorite_id = 1
    end

    @favorite = Favorite.new

    column_names = []
    @columns.each do |column|
      column_names << column.name
    end
    
    column_names.reject! do |column_name| 
      column_name == "id" ||
      column_name == "updated_at" || column_name == "created_at"
    end

    @column_names_for_new_favorite = column_names
  end
  
  def create
    begin
      @favorite = Favorite.new(favorite_params)
      @favorite.save!
      flash[:notice] = "#{@favorite.model_name.name}モデルレコードを作成しました<br>id = #{@favorite.id}"
      redirect_to demo_admin_dashboard_favorites_path
    rescue ActiveRecord::RecordInvalid => e
      @favorite = e.record
      p e.message
      flash[:alert] = "#{@favorite.model_name.name}モデルレコードを作成できませんでした"
      redirect_to new_demo_admin_dashboard_favorites_path
    end
  end
  
  def destroy
    @favorite = Favorite.find(params[:id])
    begin
      @favorite.destroy
      flash[:notice] = "#{@favorite.model_name.name}モデルレコードを削除しました<br>id = #{@favorite.id}"
      redirect_to demo_admin_dashboard_favorites_path
      
    rescue => e
      flash[:alert] = "#{@favorite.model_name.name}モデルレコードを削除できませんでした"
      redirect_to demo_admin_dashboard_favorites_path
      
    end
  end



  private
  
  def set_favorite_model_name
    @model_name = Favorite.model_name.name
  end
  
  def set_column_names_of_favorite_model
    @columns = ActiveRecord::Base.connection.columns(:favorites)
    
    column_names = []
    @columns.each do |column|
      column_names << column.name
    end
    @column_names = column_names

  end
  
  def favorite_params
    params.require(:favorite).permit(@column_names)
  end

end
