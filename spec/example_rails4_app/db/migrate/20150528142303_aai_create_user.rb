class AaiCreateUser < ActiveRecord::Migration
  def change

    create_table(:users) do |t|
      t.string :uid
      t.string :raw_data
      t.timestamps
    end

    # if ActiveRecord::Base.connection.adapter_name == "PostgreSQL"
    #   add_column :users, :raw_data, :json
    # else
    #   add_column :users, :raw_data, :string
    # end

    add_index :users, :uid, :unique => true
  end
end
