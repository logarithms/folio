class Roundtrip < ActiveRecord::Base
  belongs_to :open, class_name: "Execution"
  belongs_to :close, class_name: "Execution"

  validates :open_id, :close_id, presence: true
  validates :open_id, :close_id, uniqueness: true

# more validations:
  # open.symbol = close.symbol
  # open.qty = close.qty
  # open.date <= close.date
  # open.id < close.id

# wash_sale = ! profit & 
# use last years wash sale = ! profit & 
  TTaxPNLTypes={short_term:"N321", long_term:"N323", wash:"N682", xxx:"yyy"}

  def costbasis
    open.trade.amount * open.qty / open.trade.qty
  end

  def close_amt
    close.trade.amount * close.qty / close.trade.qty
  end

  def profit
    costbasis + close_amt
  end

  def profit?
    profit >= 0
  end

  def term
    close.trade.date - open.trade.date
#    num_days = (Date.strptime(@selldate, "%m/%d/%Y") - Date.strptime(@date, "%m/%d/%Y")).to_i
  end

  def long_term?
    term > 365
  end

  def short_term?
    ! long_term?
  end

  def long_or_short_term
    result = :long_term if long_term?
    result = :short_term if short_term?
    result
  end

  def wash?
#    ! profit?
# && no activity in the future <30 days
    false
  end

  def tax_code
    code = TTaxPNLTypes[:long_term] if long_term?
    code = TTaxPNLTypes[:short_term] if short_term?
    code = TTaxPNLTypes[:wash] if wash?
    code
  end

end
