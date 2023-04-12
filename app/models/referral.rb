class Referral < ApplicationRecord
  belongs_to :user, :foreign_key => :referrer_id
end
