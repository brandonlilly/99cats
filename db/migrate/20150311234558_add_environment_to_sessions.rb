class AddEnvironmentToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :environment, :string
    add_column :sessions, :ip, :string
  end
end
