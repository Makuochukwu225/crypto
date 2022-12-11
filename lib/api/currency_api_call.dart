import 'dart:convert';

import 'package:http/http.dart' as http;
import '../Constants/constant.dart';

class CurrencyApiCall {
  static Future getCryptoPrices(
      String to, String from, String amount, String multiply) async {
    var response = await http.get(
        Uri.parse(
            "https://api.apilayer.com/currency_data/convert?to=$to&from=$from&amount=$amount"),
        headers: {
          'apikey': AppConstants.currencyKey,
        });
    if (response.statusCode == 200) {
      return json.decode(response.body)['result'].toString();
    } else {
      return Exception();
    }
  }
}
