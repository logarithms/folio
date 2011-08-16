class TradeImporter
  ValidActions=[:buy_long,:sell_short,:sell_long,:buy_short]
  Indices={date:0, ameritradeid:1, action:2, qty:3, symbol:4, amount:7}
  # 01/02/2009,123345678,Sold 500 DIA @ 90.25,500,DIA,90.25,9.99,45114.75,25233.15,0.26,,,

#----------------------------------------------------------------
  def self.decipher_action action
    my_action = action
    my_action.gsub! /^Bought [1-9].*/, :buy_long.to_s
    my_action.gsub! /^Sold [1-9].*/, :sell_long.to_s
    my_action.gsub! /^REMOVAL OF OPTION DUE TO EXPIRATION.*/, :sell_long.to_s # <<<<<< There will be more complicated options for options...
    my_action.gsub! /^Bought to Cover [1-9].*/, :buy_short.to_s
    my_action.gsub! /^Sold Short [1-9].*/, :sell_short.to_s
    my_action
  end

#----------------------------------------------------------------
  def self.read_trades_from_file_for year
#    Trade.delete_all("qty >= 0")
    @rejects = []
     data={}
    File.new("data/Ameritrade-" + year + ".csv").readlines.map { |line|
      all_elements = line.chomp.split /,/

      if all_elements.size < Indices[:amount] then
        @rejects << [:short_record, all_elements]
        next
      end

      Indices.each { |field,index|
        data[field] = all_elements[index]
      }

      unless ValidActions.include? decipher_action(data[:action]).to_sym
        @rejects << [:invalid_action, all_elements]
        next
      end

      Trade.create(
          ameritradeid:	data[:ameritradeid],
          state:	:opened,
          amount:	data[:amount].to_f,
          qty:		data[:qty].to_i,
          symbol:	data[:symbol],
          action:	decipher_action(data[:action]),
          date:		data[:date].sub(/(\d{1,2})\/(\d{1,2})\/(\d{1,4})/, '\2/\1/\3')
      )
    }
  end
#----------------------------------------------------------------
end
