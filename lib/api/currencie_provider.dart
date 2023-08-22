import 'package:api_consume/models/currencie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Currencie> getCurrencie() async {
  const url = 'https://api.frankfurter.app/latest';
  final answer = await http.get(Uri.parse(url));
  if (answer.statusCode == 200) {
    String body = utf8.decode(answer.bodyBytes);

    final jsonList = jsonDecode(body);

    final currencie = Currencie.fromJson(jsonList);

    return currencie;
  } else {
    throw Exception(' Ocurrio Algo ${answer.statusCode}');
  }
}
