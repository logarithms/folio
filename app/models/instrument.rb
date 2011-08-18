class Instrument
  Map = {
    C: "CITIGROUP INC",
    XLF: "FINL SELECT SECTOR SPDR TR",
    XLE: "ENERGY SELECT SECTOR SPDR TR",
    GOOG: "GOOGLE INC",
    DIA: "DIAMONDS TRUST SERIES 1",
    LSI: "LSI CORP",
    STXAG: "STX CALL JAN 35",
    SPY: "SPY vs. SPy",
    KBE: "Retail Banking ETF",
  };

  def name symbol
    Map[symbol]
  end
end
