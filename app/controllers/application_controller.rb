class ApplicationController < ActionController::Base

  before_action :configure_permitted_parameters, if: :devise_controller?
  # before_action :set_table_names
  before_action :set_column_names
  
  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :gender])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :self_introduction])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :self_introduction, :profile_image])
  end
  
  # def set_table_names
  #   @table_names = ActiveRecord::Base.connection.tables.map{|t| t.classify}
      
  #   @table_names = @table_names.drop(2)
  # end

  def set_column_names
    table_names = ActiveRecord::Base.connection.tables.drop(2)
    @columns = []
    table_names.each do |table_name|
      @columns << ActiveRecord::Base.connection.columns(table_name)
    end
  end
end
