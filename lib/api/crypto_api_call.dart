import 'package:crypto/models/payload.dart';
import 'package:http/http.dart' as http;
import '../Constants/constant.dart';

class CryptoApiCall {
  static Future<Payload> getCryptoPrices() async {
    var response = await http.get(Uri.parse(AppConstants.cryptoLink), headers: {
      'X-CMC_PRO_API_KEY': AppConstants.cryptoKey,
    });

    if (response.statusCode == 200) {
      return payloadFromJson(response.body);
    } else {
      return Future.value();
    }
  }
}
