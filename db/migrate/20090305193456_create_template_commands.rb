class CreateTemplateCommands < ActiveRecord::Migration
  def self.up
    create_table :template_commands do |t|
      t.belongs_to :template, :command
      t.timestamps
    end
  end

  def self.down
    drop_table :template_commands
  end
end
