class AddAccessStartedAtToUsers < ActiveRecord::Migration[5.0]
  def up
    execute "SET SESSION sql_mode = ''"
    add_column :users, :access_started_at, :datetime, default: nil
  end

  def down
    remove_column :users, :access_started_at
  end
end
