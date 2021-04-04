class DemoAdmin::Dashboard::ReactionsController < DemoAdmin::DashboardController
  layout 'demo_admin/dashboard/application.html.erb'

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
    begin 
      @reaction.update(reaction_params)
      flash[:notice] = "#{@reaction.model_name.name}モデルレコードを更新しました<br>id = #{@reaction.id}"
      redirect_to demo_admin_dashboard_reaction_path(@reaction)
    rescue ArgumentError, ActiveRecord::NotNullViolation => e
      flash[:alert] = "#{@reaction.model_name.name}モデルレコードを更新できませんでした"
      redirect_to edit_demo_admin_dashboard_reaction_path(@reaction)
    end
  end
  
  def new
    if Reaction.all.present?
      reactions = Reaction.all
      @new_reaction_id = reactions.last.id+1
    else
      @new_reaction_id = 1
    end
    
    @reaction = Reaction.new
    
    column_names = []
    @columns.each do |column|
      column_names << column.name
    end
    
    column_names.reject! do |column_name| 
      column_name == "id" ||
      column_name == "updated_at" || column_name == "created_at"
    end
    
    @column_names_for_new_reaction = column_names
  end
  
  def create
    begin
      @reaction = Reaction.new(reaction_params)
      @reaction.save!
      flash[:notice] = "#{@reaction.model_name.name}モデルレコードを作成しました<br>id = #{@reaction.id}"
      redirect_to demo_admin_dashboard_reactions_path
    rescue ActiveRecord::RecordInvalid => e
      flash[:alert] = "#{@reaction.model_name.name}モデルレコードを作成できませんでした"
      redirect_to new_demo_admin_dashboard_reactions_path
      @reaction = e.record
      p e.message
    end
  end
  
  def destroy
    @reaction = Reaction.find(params[:id])
    begin
      @reaction.destroy
      flash[:notice] = "#{@reaction.model_name.name}モデルレコードを削除しました<br>id = #{@reaction.id}"
      redirect_to demo_admin_dashboard_reactions_path
    rescue
      flash[:alert] = "#{@reaction.model_name.name}モデルレコードを削除できませんでした"
      redirect_to demo_admin_dashboard_reactions_path
    end
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

end
