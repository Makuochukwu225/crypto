class Usd {
  Usd({
    this.price,
    this.volume24H,
    this.percentChange1H,
    this.percentChange24H,
    this.percentChange7D,
    this.marketCap,
    this.lastUpdated,
  });

  double? price;
  double? volume24H;
  double? percentChange1H;
  double? percentChange24H;
  double? percentChange7D;
  double? marketCap;
  DateTime? lastUpdated;

  factory Usd.fromJson(Map<String, dynamic> json) => Usd(
        price: json["price"] == null ? null : json["price"].toDouble(),
        volume24H:
            json["volume_24h"] == null ? null : json["volume_24h"].toDouble(),
        percentChange1H: json["percent_change_1h"] == null
            ? null
            : json["percent_change_1h"].toDouble(),
        percentChange24H: json["percent_change_24h"] == null
            ? null
            : json["percent_change_24h"].toDouble(),
        percentChange7D: json["percent_change_7d"] == null
            ? null
            : json["percent_change_7d"].toDouble(),
        marketCap:
            json["market_cap"] == null ? null : json["market_cap"].toDouble(),
        lastUpdated: DateTime.parse(json["last_updated"]),
      );

  Map<String, dynamic> toJson() => {
        "price": price,
        "volume_24h": volume24H,
        "percent_change_1h": percentChange1H,
        "percent_change_24h": percentChange24H,
        "percent_change_7d": percentChange7D,
        "market_cap": marketCap,
        "last_updated": lastUpdated!.toIso8601String(),
      };
}
