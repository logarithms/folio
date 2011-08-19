class TradeImporter
  ValidActionPositions=[:buy_long,:sell_short,:sell_long,:buy_short]
  Indices={date:0, ameritradeid:1, action_position:2, qty:3, symbol:4, amount:7}
  # 01/02/2009,123345678,Sold 500 DIA @ 90.25,500,DIA,90.25,9.99,45114.75,25233.15,0.26,,,

#----------------------------------------------------------------
  def self.decipher_action_position action_position
    my_action_position = action_position
    my_action_position.gsub! /^Bought [1-9].*/, :buy_long.to_s
    my_action_position.gsub! /^Sold [1-9].*/, :sell_long.to_s
    my_action_position.gsub! /^REMOVAL OF OPTION DUE TO EXPIRATION.*/, :sell_long.to_s # <<<<<< There will be more complicated options for options...
    my_action_position.gsub! /^Bought to Cover [1-9].*/, :buy_short.to_s
    my_action_position.gsub! /^Sold Short [1-9].*/, :sell_short.to_s
    my_action_position
  end

  def self.buy_or_sell action_position
    ((decipher_action_position(action_position) =~ /buy/) ? :buy : :sell)
  end

  def self.long_or_short_position action_position
    ((decipher_action_position(action_position) =~ /long/) ? :long : :short)
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

      unless ValidActionPositions.include? decipher_action_position(data[:action_position]).to_sym
        @rejects << [:invalid_action_position, all_elements]
        next
      end

#next unless [:C, :XLF].include? data[:symbol].to_sym
      Trade.create(
          ameritradeid:	data[:ameritradeid],
          state:	:opened,
          amount:	data[:amount].to_f,
          qty:		data[:qty].to_i,
          symbol:	data[:symbol],
          action:	buy_or_sell(data[:action_position]),
          position:	long_or_short_position(data[:action_position]),
          date:		data[:date].sub(/(\d{1,2})\/(\d{1,2})\/(\d{1,4})/, '\2/\1/\3')
      )
    }
  end
#----------------------------------------------------------------
end
