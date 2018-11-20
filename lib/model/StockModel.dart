class StockModel {
  final String code;
  final String name;
  final String close;
  final String change;
  final String changePercent;
  final String mktType;
  final String codeLD;
  final String nameLD;
  final String closeLD;
  final String changeLD;
  final String changePercentLD;
  final String mktTypeLD;

  StockModel({
    this.code,
    this.name,
    this.close,
    this.change,
    this.changePercent,
    this.mktType,
    this.codeLD,
    this.nameLD,
    this.closeLD,
    this.changeLD,
    this.changePercentLD,
    this.mktTypeLD
  });

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
        code: json['code'],
        name: json['name'],
        close: json['close'],
        change: json['change'],
        changePercent: json['changePercent'],
        mktType: json['mktType'],
        codeLD: json['codeLD'],
        nameLD: json['nameLD'],
        closeLD: json['closeLD'],
        changeLD: json['changeLD'],
        changePercentLD: json['changePercentLD'],
        mktTypeLD: json['mktTypeLD']
    );
  }
}