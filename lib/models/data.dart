import 'package:crypto/models/platform.dart';
import 'package:crypto/models/quotes.dart';

class Data {
  Data({
    this.id,
    this.name,
    this.symbol,
    this.slug,
    this.numMarketPairs,
    this.dateAdded,
    this.maxSupply,
    this.circulatingSupply,
    this.totalSupply,
    this.platform,
    this.cmcRank,
    this.lastUpdated,
    this.quote,
  });

  int? id;
  String? name;
  String? symbol;
  String? slug;
  int? numMarketPairs;
  DateTime? dateAdded;

  double? maxSupply;
  double? circulatingSupply;
  double? totalSupply;
  Platform? platform;
  int? cmcRank;
  DateTime? lastUpdated;
  Quote? quote;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        symbol: json["symbol"],
        slug: json["slug"],
        numMarketPairs: json["num_market_pairs"],
        dateAdded: DateTime.parse(json["date_added"]),
        maxSupply:
            json["max_supply"] == null ? null : json["max_supply"].toDouble(),
        circulatingSupply: json["circulating_supply"] == null
            ? null
            : json["circulating_supply"].toDouble(),
        totalSupply: json["total_supply"] == null
            ? null
            : json["total_supply"].toDouble(),
        platform: json["platform"] == null
            ? null
            : Platform.fromJson(json["platform"]),
        cmcRank: json["cmc_rank"],
        lastUpdated: DateTime.parse(json["last_updated"]),
        quote: Quote.fromJson(json["quote"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "symbol": symbol,
        "slug": slug,
        "num_market_pairs": numMarketPairs,
        "date_added": dateAdded!.toIso8601String(),
        "max_supply": maxSupply,
        "circulating_supply": circulatingSupply,
        "total_supply": totalSupply,
        "platform": platform == null ? null : platform!.toJson(),
        "cmc_rank": cmcRank,
        "last_updated": lastUpdated!.toIso8601String(),
        "quote": quote!.toJson(),
      };
}
