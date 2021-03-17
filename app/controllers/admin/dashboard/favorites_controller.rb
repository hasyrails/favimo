class Admin::Dashboard::FavoritesController < ApplicationController
  before_action :admin_user
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
    @favorite.update(favorite_params)
  end


  
  def destroy
    @favorite = Favorite.find(params[:id])
    @favorite.destroy
    redirect_to admin_dashboard_favorites_path
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

  def admin_user
    redirect_to(root_path) if  current_user.nil? || !current_user.admin?
  end

end
