// ignore_for_file: prefer_null_aware_operators, constant_identifier_names

import 'package:crypto/provider/crypto_provider.dart';
import 'package:crypto/provider/currency_provider.dart';
import 'package:crypto/screens/my_home_page.dart';
import 'package:crypto/style/color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CryptoProvider()),
        ChangeNotifierProvider(create: (_) => CurrencyProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: AppColor.primary,
          ),
          scaffoldBackgroundColor: AppColor.primary,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}
