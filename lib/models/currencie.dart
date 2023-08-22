// To parse this JSON data, do
//
//     final Currencie = CurrencieFromJson(jsonString);

import 'dart:convert';

Currencie currencieFromJson(String str) => Currencie.fromJson(json.decode(str));

String currencieToJson(Currencie data) => json.encode(data.toJson());

// class Currencies {
//   List<Currencie> items = [];
//   Currencies();
//   Currencies.fromJsonList(jsonList) {
//     if (jsonList == null) return;
//     print('Entro \n $jsonList');
//     // for (var elemento in jsonList) {
//     //   print(elemento);
//     //   final gif = Currencie.fromJson(elemento);
//     //   items.add(gif);
//     // }
//     Map<String, dynamic> var1 = {};
//     jsonList.forEach((key, value) {
//       print(Exception(' Ocurrio Algo'));
//       var1.addAll({key: value});

//       final obj = Currencie.fromJson(var1);
//       items.add(obj);
//     });
//   }
// }

class Currencie {
  final int amount;
  final String base;
  final DateTime? date;
  final Map<String, double> rates;

  Currencie({
    required this.amount,
    required this.base,
    required this.date,
    required this.rates,
  });

  factory Currencie.fromJson(Map<String, dynamic> json) => Currencie(
        amount: json["amount"],
        base: json["base"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        rates: Map.from(json["rates"]!)
            .map((k, v) => MapEntry<String, double>(k, v?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "base": base,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "rates": Map.from(rates).map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}
