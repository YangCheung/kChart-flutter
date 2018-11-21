class StockQuoteModel {
  final String stockCode;
  final String stockName;
  final String jys;
  final String exchange;
  final double changePercent;
  final double trade;
  final double open;
  final double high;
  final double low;
  final double settlement;
  final double volume;
  final double turnOverRatio;
  final double amount;
  final double pe_ttm;
  final double pb;
  final double mktcap;
  final double nmc;
  final String tradingPhaseCode;
  final String updateTime;
  final double totalCapital;
  final double flowCapital;
  final double max52;
  final double min52;

  StockQuoteModel({
    this.stockCode,
    this.stockName,
    this.jys,
    this.exchange,
    this.changePercent,
    this.trade,
    this.open,
    this.high,
    this.low,
    this.settlement,
    this.volume,
    this.turnOverRatio,
    this.amount,
    this.pe_ttm,
    this.pb,
    this.mktcap,
    this.nmc,
    this.tradingPhaseCode,
    this.updateTime,
    this.totalCapital,
    this.flowCapital,
    this.max52,
    this.min52
  });

  factory StockQuoteModel.fromJson(Map<String, dynamic> json) {
    return StockQuoteModel(
        stockCode: json['stockCode'],
        stockName: json['stockName'],
        jys: json['jys'],
        exchange: json['exchange'],
        changePercent: json['changePercent'],
        trade: json['trade'],
        open: json['open'],
        high: json['high'],
        low: json['low'],
        settlement: json['settlement'],
        volume: json['volume'],
        turnOverRatio: json['turnOverRatio'],
        amount: json['amount'],
        pe_ttm: json['pe_ttm'],
        pb: json['pb'],
        mktcap: json['mktcap'],
        nmc: json['nmc'],
        tradingPhaseCode: json['tradingPhaseCode'],
        updateTime: json['updateTime'],
        totalCapital: json['totalCapital'],
        flowCapital: json['flowCapital'],
        max52: json['max52'],
        min52: json['min52']
    );
  }
}