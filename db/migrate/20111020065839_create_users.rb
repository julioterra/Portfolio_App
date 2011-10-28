class CreateUsers < ActiveRecord::Migration
  def change
    # create a table called users, and provide a reference to the table (t) as a parameter
    create_table :users do |t|
      t.string :name
      t.string :email
      t.timestamps
    end
  end
end
