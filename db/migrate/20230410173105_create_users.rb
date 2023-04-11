class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :referred_by
      t.string :type, null: false 

      t.timestamps
    end
  end
end
