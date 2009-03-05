class AddUrlToCommands < ActiveRecord::Migration
  def self.up
    add_column :commands, :url, :string
    add_column :commands, :description, :string
  end

  def self.down
    remove_column :commands, :description
    remove_column :commands, :url
  end
end
