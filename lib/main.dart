import 'package:api_consume/API/currencie_provider.dart';
import 'package:flutter/material.dart';

import 'models/currencie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Currencie> _list;

  @override
  void initState() {
    super.initState();
    _list = getCurrencie();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: FutureBuilder<Currencie>(
            future: _list,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.rates['IDR'].toString());
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
