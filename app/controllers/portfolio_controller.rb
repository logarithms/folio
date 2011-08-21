class PortfolioController < ApplicationController
  # GET /portfolio
  # GET /portfolio.xml
  # GET /portfolio.json
  def index
    @portfolio = (Trade.unmatched.s_buy_long.in_execution_order | Trade.unmatched.s_sell_short.in_execution_order)

#@xx=Trade.find(:all,
#  :select => "SUM(trades.qty) - SUM(executions.qty) as tot_qty, SUM(trades.amount) - SUM(executions.qty*trades.amount/trades.qty) as tot_cost, trades.symbol, trades.position_cd, trades.action_cd",
#  :group => "trades.symbol, trades.position_cd, trades.action_cd",
#)
    @balance = {}
    Trade.find(:all,
      :select => "SUM(trades.qty) as tot_qty, SUM(trades.amount) as tot_cost, trades.symbol, trades.position_cd, trades.action_cd",
      :conditions => "(action_cd = #{Trade.actions.buy} AND position_cd = #{Trade.positions.long}) OR (action_cd = #{Trade.actions.sell} AND position_cd = #{Trade.positions.short})",
      :group => "trades.symbol, trades.position_cd",
    ).each {|instrument|
      @balance[instrument.symbol] ||= {}
      @balance[instrument.symbol].merge!({instrument.position => { tot_qty: instrument.tot_qty, tot_cost: instrument.tot_cost} } )
    }

    sold=Trade.find(:all,
      :select => "SUM(executions.qty) as tot_qty, SUM(executions.qty*trades.amount/trades.qty) as tot_cost, trades.symbol, trades.position_cd, trades.action_cd",
      :conditions => "(action_cd = #{Trade.actions.buy} AND position_cd = #{Trade.positions.long}) OR (action_cd = #{Trade.actions.sell} AND position_cd = #{Trade.positions.short})",
      :joins => "LEFT JOIN executions ON trades.id = executions.trade_id",
      :group => "trades.symbol, trades.position_cd",
    ).each{|instrument|
     @balance[instrument.symbol][instrument.position][:tot_qty] -= instrument.tot_qty if instrument.tot_qty
     @balance[instrument.symbol][instrument.position][:tot_cost] -= instrument.tot_cost if instrument.tot_cost
    }

#bought=Trade.s_buy_long.group(:symbol).sum(:qty).sum(:amount)
#sold=Trade.s_sell_long.group(:symbol).sum(:qty).sum(:amount)
#@xx=balance=bought.collect{|sym,qty|; {symbol: sym, action: :buy, position: :long, tot_qty: qty, tot_cost: 0 }}

#Trade.where(:state_cd => Trade.states.partial).s_buy_long.group(:symbol)
#Trade.unmatched.s_buy_long.group(:symbol).sum(:qty)

#t = Arel::Table.new :trades
#e = Arel::Table.new :executions
#joiner=t.join(:executions).on(t[:id].eq(e[:trade_id])).group(t[:symbol])
#cond=joiner.where(t[:state_cd].eq(Trade.states.partial)).where(t[:action_cd].eq(Trade.actions.buy)).where(t[:position_cd].eq(Trade.positions.long))
#cols=cond.project(t[:symbol]).project(e[:qty].sum)
#query=cols
#@summary = Trade.find_by_sql(query.to_sql)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @portfolio }
      format.json { render :json => @portfolio }
    end
  end

end
