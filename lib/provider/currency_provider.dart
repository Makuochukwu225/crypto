import 'package:crypto/api/currency_api_call.dart';
import 'package:flutter/material.dart';

class CurrencyProvider extends ChangeNotifier {
  String data = "";
  bool loading = false;
  bool error = false;

  getCrypto(String to, String from, String amount, String multiplier) async {
    loading = true;
    notifyListeners();
    try {
      String result =
          await CurrencyApiCall.getCryptoPrices(to, from, amount, multiplier);
      debugPrint(result);
      double myResult = double.parse(result.toString());
      double myMultiplier = double.parse(multiplier);
      double finalResult = (myResult * myMultiplier);
      data = finalResult.toStringAsFixed(0);
      loading = false;
      notifyListeners();
    } catch (e) {
      error = true;
      notifyListeners();
      debugPrint(e.toString());
    }
  }
}
