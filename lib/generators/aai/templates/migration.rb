class AaiCreateUser < ActiveRecord::Migration
  def change

    create_table(:users) do |t|
      t.string :uid
      t.string :unique_id
      t.string :persistent_id
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :home_organization
      t.text :raw_data
      t.timestamps
    end

    # if ActiveRecord::Base.connection.adapter_name == "PostgreSQL"
    #   add_column :users, :raw_data, :json
    # else
    #   add_column :users, :raw_data, :string
    # end

    add_index :users, :uid, unique: true
    add_index :users, :unique_id, unique: true
    add_index :users, :persistent_id, unique: true
  end
end
