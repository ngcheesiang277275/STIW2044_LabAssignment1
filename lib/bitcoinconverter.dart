import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class BitCoin extends StatelessWidget {
  const BitCoin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('BitCoin Converter'),
          backgroundColor: const Color.fromARGB(255, 247, 171, 33),
        ),
        body: const SingleChildScrollView(
          child: BitCoinForm(),
          // const ElevatedButton(onPressed: null, child: Text('Convert')),
        ),
      ),
    );
  }
}

class BitCoinForm extends StatefulWidget {
  const BitCoinForm({Key? key}) : super(key: key);

  @override
  State<BitCoinForm> createState() => _BitCoinFormState();
}

class _BitCoinFormState extends State<BitCoinForm> {
  TextEditingController valueOneEditingController = TextEditingController();
  // TextEditingController valueTwoEditingController = TextEditingController();

  String currencySelected = "eth", name = "N/A", unit = "N/A", type = "N/A";

  double value = 0.0, convertedValue = 0.0, bitCoinValue = 0.0;

  List<String> currencyList = [
    "btc",
    "eth",
    "ltc",
    "bch",
    "bnb",
    "eos",
    "xrp",
    "xlm",
    "link",
    "dot",
    "yfi",
    "usd",
    "aed",
    "ars",
    "aud",
    "bdt",
    "bhd",
    "bmd",
    "brl",
    "cad",
    "chf",
    "clp",
    "cny",
    "czk",
    "dkk",
    "eur",
    "gbp",
    "hkd",
    "huf",
    "idr",
    "ils",
    "inr",
    "jpy",
    "krw",
    "kwd",
    "lkr",
    "mmk",
    "mxn",
    "myr",
    "ngn",
    "nok",
    "nzd",
    "php",
    "pkr",
    "pln",
    "rub",
    "sar",
    "sek",
    "sgd",
    "thb",
    "try",
    "twd",
    "uad",
    "vef",
    "vnd",
    "zar",
    "xdr",
    "xag",
    "xau",
    "bits",
    "sats",
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(25),
        child: Column(children: [
          const Text(
            'BitCoin',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TextField(
            textAlign: TextAlign.center,
            controller: valueOneEditingController,
            keyboardType: const TextInputType.numberWithOptions(),
            decoration: InputDecoration(
                hintText: "Please input BitCoin value.",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(35))),
          ),
          DropdownButton(
            itemHeight: 50,
            value: currencySelected,
            onChanged: (newValue) {
              setState(() {
                currencySelected = newValue.toString();
              });
            },
            items: currencyList.map((currencySelected) {
              return DropdownMenuItem(
                child: Text(
                  currencySelected,
                ),
                value: currencySelected,
              );
            }).toList(),
          ),
          Center(
            child: Container(
              width: 350,
              height: 200,
              padding: const EdgeInsets.all(5.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                child: Column(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      ("Result:\n" +
                          convertedValue.toString() +
                          " " +
                          unit.toUpperCase()),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ]),
                  const SizedBox(height: 12),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      ("Name:\n" + name),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                    )
                  ]),
                  const SizedBox(height: 8),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      ("Unit:\n" + unit),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                    )
                  ]),
                  const SizedBox(height: 8),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      ("Value:\n" + value.toString()),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                    )
                  ]),
                  const SizedBox(height: 8),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      ("Type:\n" + type),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                    )
                  ]),
                ]),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _convert,
            child: const Text(
              'Convert',
              style: TextStyle(fontSize: 16),
            ),
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(const Size(150, 50)),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35.0),
                ),
              ),
            ),
          )
        ]));
  }

  Future<void> _convert() async {
    var url = Uri.parse('https://api.coingecko.com/api/v3/exchange_rates');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = response.body;
      var parsedData = json.decode(jsonData);

      if (valueOneEditingController.text.isEmpty) {
        Fluttertoast.showToast(
            msg: "Invalid input.\nMake sure to input BitCoin value.");
      } else {
        bitCoinValue = double.parse(valueOneEditingController.text);
        Fluttertoast.showToast(msg: "Conversion is done.");

        name = parsedData['rates'][currencySelected]['name'];
        value = parsedData['rates'][currencySelected]['value'];
        unit = parsedData['rates'][currencySelected]['unit'];
        type = parsedData['rates'][currencySelected]['type'];
      }

      setState(() {
        convertedValue = bitCoinValue * value;
      });
    } else {
      setState(() {
        const Text('No record');
      });
    }
  }
}
