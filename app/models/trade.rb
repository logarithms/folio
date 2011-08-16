class Trade < ActiveRecord::Base

  has_many :executions
  has_many     :roundtrips,
               :through               => :executions,
               :source                => :roundtrip
  validates :ameritradeid, :uniqueness => true
  validates :ameritradeid, :symbol, :date, :action, :state, :qty, :amount, :presence => true

#----------------------------------------------------------------
  as_enum :action, [:buy_long, :sell_short, :sell_long, :buy_short], prefix: true
  validates_as_enum :action

  as_enum :state, [:opened, :partial, :closed], prefix: true
#  defaults state: :opened
  validates_as_enum :state

#----------------------------------------------------------------
  scope :in_execution_order, order(:ameritradeid)
  scope :closing, where("action_cd in (?,?)", Trade.actions.sell_long, Trade.actions.buy_short)
  scope :unmatched, where("state_cd in (?,?)", Trade.states.opened, Trade.states.partial)
  scope :contra_trades, lambda{|symbol, counteraction_cd|; where(symbol: symbol, action_cd: counteraction_cd)}

#----------------------------------------------------------------
  def buy_or_sell
    ((action =~ /buy/) ? :buy : :sell)
  end

  def long_or_short_action
    ((action =~ /long/) ? :long : :short)
  end

  def counteraction
    {buy_long: :sell_long, sell_short: :buy_short, sell_long: :buy_long, buy_short: :sell_short}[action]
  end

  def counteraction_cd
    self.class.actions counteraction
  end

  def unmatched_qty
    qty - executions.sum(:qty)
  end

  def name
    symbol
  end
#----------------------------------------------------------------

end
