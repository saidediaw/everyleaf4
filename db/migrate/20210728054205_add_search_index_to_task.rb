class AddSearchIndexToTask < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :search, :string
    add_index :tasks, :search
  end
end
