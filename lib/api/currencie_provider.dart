import 'package:api_consume/models/currencie.dart';
import 'package:api_consume/models/rate.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Currencie> getCurrencieValue() async {
  const url = 'https://api.frankfurter.app/latest';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    String body = utf8.decode(response.bodyBytes);

    final jsonList = jsonDecode(body);

    final currencie = Currencie.fromJson(jsonList);

    return currencie;
  } else {
    throw Exception(' Ocurrio Algo ${response.statusCode}');
  }
}

Future<List<Rate>> getCurrencies() async {
  List<Rate> currencies = [];
  const apiUrl = 'https://api.frankfurter.app/currencies';
  final response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    final currencyData = json.decode(response.body);
    currencyData.forEach((code, name) {
      currencies.add(Rate(code: code, name: name));
    });

    return currencies;
  } else {
    throw Exception('Ocurrio Algo ${response.statusCode}');
  }
}
