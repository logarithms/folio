class Execution < ActiveRecord::Base

  validates :trade_id, :qty, :presence => true

  belongs_to :trade
  has_one :round_trip

  def amount
    trade.amount * qty / trade.qty
  end

end
