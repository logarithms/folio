class PortfolioController < ApplicationController
  # GET /portfolio
  # GET /portfolio.xml
  # GET /portfolio.json
  def index
    @portfolio = (Trade.unmatched.s_buy_long.in_execution_order | Trade.unmatched.s_sell_short.in_execution_order)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @portfolio }
      format.json { render :json => @portfolio }
    end
  end

end
