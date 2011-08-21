class BatchController < ApplicationController
  def index
    @processing_date = DateTime.now.to_date.strftime "%m/%d/%Y"
    @files = Dir.glob("data/Ameritrade-*.csv") .each { |s|
        s.gsub! /data\/Ameritrade-(.*).csv/, '\1'
    }
    #@files = %x[dir /B data\\Ameritrade-*.csv ].split .each { |s|; s.gsub!(/Ameritrade-(.*).csv/,'\1')}
    # @files = %x[dir /B data | find "Ameritrade-" | find ".csv" ].split .each { |s|; s.gsub!(/Ameritrade-(.*).csv/,\1)}
  end

  def import
    TradeImporter.read_trades_from_file_for params[:year]
  end

  def match
    MatchMaker.match_trades params[:year]
  end

  def trunc
    Trade.delete_all
    Execution.delete_all
    Roundtrip.delete_all
  end

end
