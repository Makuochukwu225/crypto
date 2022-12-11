import 'package:crypto/models/usd.dart';


class Quote {
  Quote({
    this.usd,
  });

  Usd? usd;

  factory Quote.fromJson(Map<String, dynamic> json) => Quote(
        usd: Usd.fromJson(json["USD"]),
      );

  Map<String, dynamic> toJson() => {
        "USD": usd!.toJson(),
      };
}
