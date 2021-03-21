class Admin::ApplicationController < ApplicationController
  layout 'admin'
  before_action :admin_user
  before_action :set_model_names
  before_action :set_model_names

  def index
    # @table_names = ActiveRecord::Base.connection.tables.map{|t| t.classify}
    
    # @table_names = @table_names.drop(2)
    
  end
  
  private
  
  def set_model_names
    table_names = ActiveRecord::Base.connection.tables.drop(2)

    @table_names = []
    table_names.each do |table_name|
     @table_names << table_name.chop
    end
  end
  
  def set_column_names
    @table_names = ActiveRecord::Base.connection.tables.drop(2)
    @columns = []
    @table_names.each do |table_name|
      @columns << ActiveRecord::Base.connection.columns(table_name)
    end
  end

  def admin_user
    redirect_to(root_path) if  current_user.nil? || !current_user.admin?
  end
end
