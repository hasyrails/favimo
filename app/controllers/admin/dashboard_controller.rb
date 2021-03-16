class Admin::DashboardController < ApplicationController
  before_action :admin_user

  def index
    # @table_names = ActiveRecord::Base.connection.tables.map{|t| t.classify}
    
    # @table_names = @table_names.drop(2)
    
    table_names = ActiveRecord::Base.connection.tables.drop(2)
    @columns = []
    table_names.each do |table_name|
      @columns << ActiveRecord::Base.connection.columns(table_name)
    end

  end

  private

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end 
end
