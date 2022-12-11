import 'package:crypto/models/payload.dart';
import 'package:flutter/material.dart';

import '../api/crypto_api_call.dart';

class CryptoProvider extends ChangeNotifier {
  Payload data = Payload();
  bool loading = false;
  bool error = false;

  getCrypto() async {
    loading = true;

    try {
      data = await CryptoApiCall.getCryptoPrices();
      notifyListeners();
      loading = false;
      notifyListeners();
    } catch (e) {
      error = true;
      notifyListeners();
      debugPrint(e.toString());
    }
  }
}
