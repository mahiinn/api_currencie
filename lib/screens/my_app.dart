import 'package:api_consume/models/currencie.dart';
import 'package:api_consume/models/flag_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  double _conversionResult = 0.0, _amount = 0.0, _Result1 = 0.0, _Result2 = 0.0;
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
        convert1();
        convert2();
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

  void convert1() async {
    final double rate = await fetchConversionRate(
      _currencyList[_selectedCurrency1Index].code,
      _currencyList[_selectedCurrency2Index].code,
    );
    setState(() {
      _Result1 = 1.0 * rate;
    });
  }

  void convert2() async {
    final double rate = await fetchConversionRate(
      _currencyList[_selectedCurrency2Index].code,
      _currencyList[_selectedCurrency1Index].code,
    );
    setState(() {
      _Result2 = 1.0 * rate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: FutureBuilder<List<Currency>>(
              future: _currencies,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Convert",
                              style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(72, 74, 98, 1)),
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () {},
                            child: Text('Currency'),
                            style: ElevatedButton.styleFrom(
                              // Cambia el color de fondo del botón
                              onPrimary: Color.fromRGBO(39, 76, 119,
                                  0.8), // Cambia el color del texto del botón
                              elevation: 0, // Cambia la elevación del botón
                              padding: EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal:
                                      15), // Cambia el padding del botón
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10), // Cambia la forma del botón
                              ),
                              side: const BorderSide(
                                width: 2.0,
                                color: Color.fromRGBO(39, 76, 119, 0.8),
                              ),
                              minimumSize: Size(108, 30),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 340,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26, //New
                                  blurRadius: 20.0,
                                  offset: Offset(0, 8))
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                DropdownButton<int>(
                                  value: _selectedCurrency1Index,
                                  underline: Container(),
                                  onChanged: (int? newValue) {
                                    setState(() {
                                      _selectedCurrency1Index = newValue!;
                                      convert1();
                                      convert2();
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
                                            Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.blue,
                                              ),
                                              child: ClipOval(
                                                child: SvgPicture.network(
                                                  _flags[entry.key].svgFlagUrl,
                                                  width: 24,
                                                  height: 16,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                width:
                                                    8), // Espacio entre la bandera y el texto
                                            Text(entry.value.toString()),
                                          ],
                                        ),
                                      );
                                    },
                                  ).toList(),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Row(
                                    children: [
                                      Text(
                                        '1',
                                        style: TextStyle(
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromRGBO(72, 74, 98, 1)),
                                      ),
                                      Text(
                                        _currencyList[_selectedCurrency1Index]
                                            .code
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromRGBO(72, 74, 98, 1)),
                                      ),
                                      Text(
                                        '=',
                                        style: TextStyle(
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromRGBO(72, 74, 98, 1)),
                                      ),
                                      Text(
                                        '$_Result1',
                                        style: TextStyle(
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromRGBO(72, 74, 98, 1)),
                                      ),
                                      Text(
                                        _currencyList[_selectedCurrency2Index]
                                            .code
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromRGBO(72, 74, 98, 1)),
                                      ),
                                    ],
                                  ),
                                ),
                                TextField(
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  onChanged: (newValue) {
                                    setState(() {
                                      _amount =
                                          double.tryParse(newValue) ?? 0.0;
                                    });
                                  },
                                  style: TextStyle(
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(72, 74, 98, 1)),
                                  decoration: InputDecoration(
                                    hintText: 'Amount',
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                ),
                                SizedBox(height: 0),
                                Row(
                                  children: [
                                    Container(
                                      width: 220,
                                      height: 1,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(216, 216, 216, 1),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          final int tempIndex =
                                              _selectedCurrency1Index;
                                          _selectedCurrency1Index =
                                              _selectedCurrency2Index;
                                          _selectedCurrency2Index = tempIndex;
                                          convertCurrencies();
                                          convert1();
                                          convert2();
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Color.fromRGBO(39, 76, 119,
                                            0.8), // Cambia el color de fondo del botón
                                        onPrimary: Color.fromRGBO(229, 232, 225,
                                            1), // Cambia el color del texto del botón
                                        elevation:
                                            0, // Cambia la elevación del botón // Cambia el padding del botón
                                        shape: CircleBorder(),
                                      ),
                                      child: SizedBox(
                                        width:
                                            40, // Ajusta el ancho del botón circular
                                        height:
                                            40, // Ajusta la altura del botón circular
                                        child: Icon(
                                          Icons.change_circle_rounded,
                                          size:
                                              35, // Ajusta el tamaño del icono
                                          color:
                                              Colors.white, // Color del icono
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                DropdownButton<int>(
                                  value: _selectedCurrency2Index,
                                  underline: Container(),
                                  onChanged: (int? newValue) {
                                    setState(() {
                                      _selectedCurrency2Index = newValue!;
                                    });
                                    convert1();
                                    convert2();
                                  },
                                  items: _currencyList
                                      .asMap()
                                      .entries
                                      .where((entry) =>
                                          entry.key != _selectedCurrency1Index)
                                      .map<DropdownMenuItem<int>>(
                                    (entry) {
                                      return DropdownMenuItem<int>(
                                        value: entry.key,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.blue,
                                              ),
                                              child: ClipOval(
                                                child: SvgPicture.network(
                                                  _flags[entry.key].svgFlagUrl,
                                                  width: 24,
                                                  height: 16,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                width:
                                                    8), // Espacio entre la bandera y el texto
                                            Text(entry.value.toString()),
                                          ],
                                        ),
                                      );
                                    },
                                  ).toList(),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Row(
                                    children: [
                                      Text(
                                        '1',
                                        style: TextStyle(
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromRGBO(72, 74, 98, 1)),
                                      ),
                                      Text(
                                        _currencyList[_selectedCurrency2Index]
                                            .code
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromRGBO(72, 74, 98, 1)),
                                      ),
                                      Text(
                                        '=',
                                        style: TextStyle(
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromRGBO(72, 74, 98, 1)),
                                      ),
                                      Text(
                                        '$_Result2',
                                        style: TextStyle(
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromRGBO(72, 74, 98, 1)),
                                      ),
                                      Text(
                                        _currencyList[_selectedCurrency1Index]
                                            .code
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromRGBO(72, 74, 98, 1)),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    '$_conversionResult',
                                    style: TextStyle(
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(72, 74, 98, 1)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      OutlinedButton(
                        onPressed: () {
                          convertCurrencies();
                        },
                        child: Text('Convert'),
                        style: ElevatedButton.styleFrom(
                          // Cambia el color de fondo del botón
                          onPrimary: Color.fromRGBO(39, 76, 119,
                              0.8), // Cambia el color del texto del botón
                          elevation: 0, // Cambia la elevación del botón
                          padding: EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 15), // Cambia el padding del botón
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Cambia la forma del botón
                          ),
                          side: const BorderSide(
                            width: 2.0,
                            color: Color.fromRGBO(39, 76, 119, 0.8),
                          ),
                          minimumSize: Size(108, 30),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
