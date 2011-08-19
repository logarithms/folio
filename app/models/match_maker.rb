class MatchMaker

  def self.match_trades year
#    Trade.unmatched.closing.in_execution_order.each{ |trade|
    (Trade.unmatched.s_buy_short.in_execution_order | Trade.unmatched.s_sell_long.in_execution_order).each{ |trade|
      while trade.unmatched_qty > 0 do
        Trade.unmatched.contra_trades(trade).in_execution_order.each{ |cost|
          match trade, cost
          break if trade.unmatched_qty == 0
        }
      end
    }
  end

  def self.match trade, cost
    cqty = cost.unmatched_qty
    my_qty = trade.unmatched_qty
    matched_qty = [my_qty,cqty].min

    position_open  = Execution.create(trade_id: cost.id, qty:matched_qty)
    position_close = Execution.create(trade_id:trade.id, qty:matched_qty)
    Roundtrip.create( open_id: position_open.id, close_id: position_close.id )

    trade.state=:partial if my_qty > cqty
    cost.state=:partial if my_qty < cqty
    trade.state=:closed if my_qty <= cqty
    cost.state=:closed if my_qty >= cqty
    cost.save
    trade.save
  end

end
