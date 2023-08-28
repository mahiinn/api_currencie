import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = 'Splash';
  const SplashScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "CURRENCY",
              style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(72, 74, 98, 1)),
            ),
            const Text(
              "TRANSFER",
              style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(72, 74, 98, 1)),
            ),
            Container(
              width: 300,
              height: 1,
              margin: const EdgeInsets.fromLTRB(30, 30, 30, 30),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 30),
              // child: const Image(
              //   image: AssetImage('assets/img/Group 64.png'),
              // ),
            ),
            Container(
              width: 300,
              height: 1,
              margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
            ),
            const Text(
              "WELCOME",
              style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(72, 74, 98, 1)),
            ),
          ],
        ),
      ),
    );
  }
}
