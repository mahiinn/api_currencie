import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class Currency {
  final String code;
  final String name;

  Currency(this.code, this.name);

  @override
  String toString() {
    return '$code - $name';
  }
}

class FlagInfo {
  final String svgFlagUrl;

  FlagInfo(this.svgFlagUrl);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Currency>> _currencies;
  late List<Currency> _currencyList = [];
  late int _selectedCurrency1Index = 0;
  late int _selectedCurrency2Index = 1;
  double _conversionResult = 0.0, _amount = 0.0;
  late List<FlagInfo> _flags;

  @override
  void initState() {
    super.initState();
    _currencies = fetchCurrencies();
  }

  Future<List<Currency>> fetchCurrencies() async {
    const apiUrl = 'https://api.frankfurter.app/currencies';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Currency> currencies = [];

      data.forEach((code, name) {
        currencies.add(Currency(code, name));
      });
      setState(() {
        _currencyList = currencies;
        _flags = List.generate(_currencyList.length, (index) => FlagInfo(''));
      });
      await fetchFlags();
      return currencies;
    } else {
      throw Exception('Failed to load currencies');
    }
  }

  Future<void> fetchFlags() async {
    for (int i = 0; i < _currencyList.length; i++) {
      final currencyCode = _currencyList[i].code;
      final response = await http.get(
        Uri.parse(
            'https://restcountries.com/v3.1/currency/$currencyCode?fields=flags'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final String svgFlagUrl = data[0]['flags']['svg'];
        setState(() {
          _flags[i] = FlagInfo(svgFlagUrl);
        });
      } else {
        throw Exception('Failed to load flag');
      }
    }
  }

  Future<double> fetchConversionRate(String from, String to) async {
    final response = await http.get(Uri.https(
      'api.frankfurter.app',
      'latest',
      {'from': from, 'to': to},
    ));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['rates'][to];
    } else {
      throw Exception('Failed to load conversion rate');
    }
  }

  void convertCurrencies() async {
    final double rate = await fetchConversionRate(
      _currencyList[_selectedCurrency1Index].code,
      _currencyList[_selectedCurrency2Index].code,
    );
    setState(() {
      _conversionResult = _amount * rate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Currency Converter'),
        ),
        body: Center(
          child: FutureBuilder<List<Currency>>(
            future: _currencies,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton<int>(
                      value: _selectedCurrency1Index,
                      onChanged: (int? newValue) {
                        setState(() {
                          _selectedCurrency1Index = newValue!;
                        });
                      },
                      items: _currencyList
                          .asMap()
                          .entries
                          .map<DropdownMenuItem<int>>(
                        (entry) {
                          return DropdownMenuItem<int>(
                            value: entry.key,
                            child: Row(
                              children: [
                                SvgPicture.network(
                                  _flags[entry.key].svgFlagUrl,
                                  width: 24,
                                  height: 16,
                                ),
                                const SizedBox(
                                    width:
                                        8), // Espacio entre la bandera y el texto
                                Text(entry.value.toString()),
                              ],
                            ),
                          );
                        },
                      ).toList(),
                    ),
                    const SizedBox(height: 20),
                    DropdownButton<int>(
                      value: _selectedCurrency2Index,
                      onChanged: (int? newValue) {
                        setState(() {
                          _selectedCurrency2Index = newValue!;
                        });
                      },
                      items: _currencyList
                          .asMap()
                          .entries
                          .where(
                              (entry) => entry.key != _selectedCurrency1Index)
                          .map<DropdownMenuItem<int>>(
                        (entry) {
                          return DropdownMenuItem<int>(
                            value: entry.key,
                            child: Row(
                              children: [
                                SvgPicture.network(
                                  _flags[entry.key].svgFlagUrl,
                                  width: 24,
                                  height: 16,
                                ),
                                const SizedBox(
                                    width:
                                        8), // Espacio entre la bandera y el texto
                                Text(entry.value.toString()),
                              ],
                            ),
                          );
                        },
                      ).toList(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50, right: 50),
                      child: TextField(
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        onChanged: (newValue) {
                          setState(() {
                            _amount = double.tryParse(newValue) ?? 0.0;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Amount',
                          hintText: 'Enter amount to convert',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          final int tempIndex = _selectedCurrency1Index;
                          _selectedCurrency1Index = _selectedCurrency2Index;
                          _selectedCurrency2Index = tempIndex;
                        });
                      },
                      child: const Text('Swap Currencies'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        convertCurrencies();
                      },
                      child: const Text('Convert'),
                    ),
                    const SizedBox(height: 20),
                    Text('Conversion Result: $_conversionResult'),
                    const SizedBox(height: 20),
                    // Mostrar la imagen SVG de la bandera aquí
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
