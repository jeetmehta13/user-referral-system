class CreateReferrals < ActiveRecord::Migration[7.0]
  def change
    create_table :referrals do |t|
      t.bigint :referrer_id, null: false
      t.string :referred_email, null: false
      t.integer :sent_count, null: false
      t.string :referral_key, null: false
      t.boolean :referral_used, null: false, default: false      
      t.timestamps
    end

    add_foreign_key :referrals, :users, column: :referrer_id
  end
end
