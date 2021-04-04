class DemoAdmin::ApplicationController < ApplicationController
  layout 'demo_admin'
  before_action :demo_admin_user
  before_action :set_model_names
  before_action :set_column_names


  def index
    # @table_names = ActiveRecord::Base.connection.tables.map{|t| t.classify}
    
    # @table_names = @table_names.drop(2)
    
  end
  
  private
  
  def set_model_names
    table_names = ActiveRecord::Base.connection.tables

    table_names.reject! do |table_name|
      table_name == "ar_internal_metadata"||table_name == "schema_migrations"
    end
    
    # binding.pry
    
    @table_names = []
    table_names.each do |table_name|
      @table_names << table_name.chop
    end
  end
  
  def set_column_names
    tables = ActiveRecord::Base.connection.tables
    
    tables.reject! do |table|
      table == "ar_internal_metadata"||table == "schema_migrations"
    end

    @columns = []
    tables.each do |table|
      @columns << ActiveRecord::Base.connection.columns(table)
    end
  end

end
