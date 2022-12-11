import 'dart:convert';

import 'package:crypto/provider/crypto_provider.dart';
import 'package:crypto/provider/currency_provider.dart';
import 'package:crypto/style/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Constants/constant.dart';
import 'package:http/http.dart' as http;
import '../models/data.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    getCrypto();
  }

  //fetch list
  getCrypto() async {
    var provider = Provider.of<CryptoProvider>(context, listen: false);
    await provider.getCrypto();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        banner(),
        buildCryptoList(),
        Text(
          "Tap the coin if you wish to check value",
          style: TextStyle(color: AppColor.secondaryVariant.withOpacity(0.3)),
        )
      ],
    ));
  }

  Widget buildCryptoList() {
    return Expanded(
      child: Consumer<CryptoProvider>(builder: ((context, value, child) {
        List<Data> filteredList = [];
        var allList = value.data.data ?? [];
        filterList(allList, filteredList);
        return value.loading
            ? value.error
                ? GestureDetector(
                    onTap: () {
                      var provider =
                          Provider.of<CryptoProvider>(context, listen: false);
                      provider.getCrypto();
                    },
                    child: Center(
                        child: Column(
                      children: [
                        Image.asset(
                          "assets/image/server_down.png",
                          height: 200,
                          width: 200,
                        ),
                        Text(
                          'Cannot connect right now\nTap to retry',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColor.secondaryVariant,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    )),
                  )
                : Center(
                    child: CupertinoActivityIndicator(
                      color: AppColor.secondaryVariant,
                      radius: 20,
                    ),
                  )
            : ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: ((context, index) {
                  return tile(context, filteredList, index);
                }));
      })),
    );
  }

  Widget banner() {
    return GestureDetector(
      onTap: () {
        var provider = Provider.of<CryptoProvider>(context, listen: false);
        provider.getCrypto();
      },
      child: const SizedBox(
        height: 200,
        width: double.infinity,
        child: Center(
          child: Text(
            'Crypto',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  //fetch image of coin
  fetchImage(String id) async {
    var response = await http.get(
        Uri.parse(
            "https://pro-api.coinmarketcap.com/v2/cryptocurrency/info?id=$id"),
        headers: {
          'X-CMC_PRO_API_KEY': AppConstants.cryptoKey,
        });
    return json.decode(response.body)['data'][id]['logo'].toString();
  }

  //filter list for the required coin [Bitcoin][Ethereum][XRP][Dogecoin][Dash][Litecoin]
  filterList(List<Data> allList, List<Data> filteredList) {
    for (var i = 0; i < allList.length; i++) {
      if (allList[i].name == "Bitcoin" ||
          allList[i].name == "Ethereum" ||
          allList[i].name == "XRP" ||
          allList[i].name == "Dogecoin" ||
          allList[i].name == "Dash" ||
          allList[i].name == "Litecoin") {
        filteredList.add(allList[i]);
      }
    }
  }

  Widget tile(BuildContext context, List<Data> b, int index) {
    return Container(
      height: 70,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              controller.text = "0";
              var provider =
                  Provider.of<CurrencyProvider>(context, listen: false);
              provider.getCrypto(
                  to, from, b[index].quote!.usd!.price.toString(), "0");
              showBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (c) {
                    return dialog(context, b, index);
                  });
            },
            child: Ink(
              color: AppColor.secondary,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FutureBuilder(
                        future: fetchImage(b[index].id.toString()),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return CircleAvatar(
                              radius: 30,
                              backgroundColor: AppColor.primaryVariant,
                              backgroundImage:
                                  NetworkImage(snapshot.data.toString()),
                            );
                          } else {
                            return CircleAvatar(
                              radius: 30,
                              backgroundColor: AppColor.primaryVariant,
                              child: const CupertinoActivityIndicator(),
                            );
                          }
                        }),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      b[index].name!,
                      style: TextStyle(
                          fontSize: 20, color: AppColor.secondaryVariant),
                    ),
                    const Spacer(),
                    Text(
                      " \$${b[index].quote!.usd!.price!.toStringAsFixed(1)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String to = "NGN";
  String from = "USD";
  String amount = "1000";
  Widget dialog(BuildContext context, List<Data> b, int index) {
    var provider = Provider.of<CurrencyProvider>(context, listen: false);
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 270,
              decoration: BoxDecoration(
                  color: AppColor.secondaryVariant,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Consumer<CurrencyProvider>(
                        builder: ((context, value, child) {
                      return value.loading
                          ? CupertinoActivityIndicator(
                              color: AppColor.primary,
                            )
                          : value.error
                              ? Text(
                                  "network error",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: AppColor.primaryVariant),
                                )
                              : Text(
                                  NumberFormat.currency(symbol: "NGN ")
                                      .format(int.parse(value.data.toString())),
                                  style: TextStyle(
                                      fontSize: 30, color: AppColor.secondary),
                                );
                    })),
                    const SizedBox(height: 20),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColor.primaryVariant.withOpacity(0.1),
                        ),
                        width: 300,
                        height: 40,
                        child: Center(
                          child: TextField(
                            controller: controller,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration.collapsed(
                                hintText: "Enter coin volume"),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 300,
                      height: 40,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primary),
                          onPressed: () {
                            if (controller.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      backgroundColor: AppColor.secondary,
                                      content:
                                          const Text("Enter coin Volume")));
                              return;
                            }
                            provider.getCrypto(
                                to,
                                from,
                                b[index].quote!.usd!.price.toString(),
                                controller.text);
                          },
                          child: const Text('Calculate')),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            width: MediaQuery.of(context).size.width,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FutureBuilder(
                  future: fetchImage(b[index].id.toString()),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColor.primaryVariant,
                        backgroundImage: NetworkImage(snapshot.data.toString()),
                      );
                    } else {
                      return CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColor.primaryVariant,
                        child: const CupertinoActivityIndicator(),
                      );
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
