class Admin::Dashboard::ReactionsController < ApplicationController
  layout 'admin/dashboard/application.html.erb'

  before_action :admin_user
  before_action :set_reaction_model_name
  before_action :set_column_names_of_reaction_model

  def index
    @reactions = Reaction.page(params[:page]).per(5)
  end

  def show
    @reaction = Reaction.find(params[:id])
  end

  def edit
    @reaction = Reaction.find(params[:id])
  end

  def update
    @reaction = Reaction.find(params[:id])
    @reaction.update(reaction_params)
  end


  
  def destroy
    @reaction = Reaction.find(params[:id])
    @reaction.destroy
    redirect_to admin_dashboard_reactions_path
  end



  private
  
  def set_reaction_model_name
    @model_name = Reaction.model_name.name
  end
  
  def set_column_names_of_reaction_model
    @columns = ActiveRecord::Base.connection.columns(:reactions)
    
    column_names = []
    @columns.each do |column|
      column_names << column.name
    end
    @column_names = column_names

  end
  
  def reaction_params
    params.require(:reaction).permit(@column_names)
  end

  def admin_user
    redirect_to(root_path) if  current_user.nil? || !current_user.admin?
  end

end
