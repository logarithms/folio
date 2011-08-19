class Trade < ActiveRecord::Base

  has_many :executions
  has_many     :roundtrips,
               :through               => :executions,
               :source                => :roundtrip
  validates :ameritradeid, :uniqueness => true
  validates :ameritradeid, :symbol, :date, :action, :position, :state, :qty, :amount, :presence => true

#----------------------------------------------------------------
  as_enum :action, [:buy, :sell], prefix: true
  validates_as_enum :action

  as_enum :position, [:long, :short], prefix: true
  validates_as_enum :position

  as_enum :state, [:opened, :partial, :closed], prefix: true
  validates_as_enum :state

#----------------------------------------------------------------
  scope :in_execution_order, order(:ameritradeid)

#closing trades
  scope :s_sell_long, where(action_cd: Trade.actions.sell, position_cd: Trade.positions.long)
  scope :s_buy_short, where(action_cd: Trade.actions.buy, position_cd: Trade.positions.short)
#opening trades
  scope :s_buy_long, where(action_cd: Trade.actions.buy, position_cd: Trade.positions.long)
  scope :s_sell_short, where(action_cd: Trade.actions.sell, position_cd: Trade.positions.short)
#RVS  scope :closing, where("action_cd in (?,?)", Trade.actions.sell_long, Trade.actions.buy_short)
#  scope :closing, lambda{
#    t = Trade.arel_table
#    t.where(t[:action_cd].eq(Trade.actions.sell).and(t[:position_cd].eq(Trade.positions.long))
#        .or(t[:action_cd].eq(Trade.actions.buy ).and(t[:position_cd].eq(Trade.positions.short))))
#  }

  scope :unmatched, where("state_cd in (?,?)", Trade.states.opened, Trade.states.partial)
  scope :contra_trades, lambda{|trade|
                          where(symbol: trade.symbol, position_cd: trade.position_cd, action_cd: trade.counteraction_cd)
                        }

#----------------------------------------------------------------
  def counteraction
    {buy: :sell, sell: :buy}[action]
  end

  def counteraction_cd
    self.class.actions counteraction
  end

  def unmatched_qty
    qty - executions.sum(:qty)
  end
require "instrument.rb"
  def name
    Instrument.new.name symbol.to_sym
  end

#----------------------------------------------------------------

end
