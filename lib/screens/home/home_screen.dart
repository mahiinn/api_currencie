// import 'package:api_consume/api/currencie_provider.dart';
// import 'package:api_consume/models/rate.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class HomeScreen extends StatefulWidget {
//   static const String routeName = 'HomeScreen';
//   const HomeScreen({
//     super.key,
//   });

//   @override
//   // ignore: library_private_types_in_public_api
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   late Future<List<Rate>> items;

//   @override
//   void initState() {
//     items = getCurrencies();
//     super.initState();
//     toStringCurrencie();
//   }

//   late List<String> _dropdownItems = [];
//   Future<void> toStringCurrencie() async {
//     try {
//       List<Rate> obj = await items;
//       setState(() {
//         for (var i in obj) {
//           _dropdownItems.add("${i.code} - ${i.name}");
//         }
//         print(_dropdownItems);
//       });
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     String selectedItem1 = 'value';
//     String selectedItem2 = 'vaule1';
//     return Scaffold(
//       body: SafeArea(
//         child: FutureBuilder(
//           future: items,
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Container(
//                           alignment: Alignment.topLeft,
//                           child: Text(
//                             "Convert",
//                             style: GoogleFonts.inter(
//                                 textStyle: const TextStyle(
//                                     color: Color.fromRGBO(72, 74, 98, 1),
//                                     fontSize: 35),
//                                 fontWeight: FontWeight.w900),
//                           ),
//                         ),
//                         OutlinedButton(
//                           onPressed: () {},
//                           style: ElevatedButton.styleFrom(
//                             // Cambia el color de fondo del botón
//                             foregroundColor:
//                                 const Color.fromRGBO(72, 74, 98, 1),
//                             elevation: 0, // Cambia la elevación del botón
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 15,
//                                 horizontal: 15), // Cambia el padding del botón
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(
//                                   10), // Cambia la forma del botón
//                             ),
//                             side: const BorderSide(
//                               width: 2.0,
//                               color: Color.fromRGBO(238, 238, 238, 1),
//                             ),
//                             minimumSize: const Size(108, 30),
//                           ),
//                           child: Text('Currency',
//                               style: GoogleFonts.inter(
//                                   textStyle: const TextStyle(
//                                       color: Color.fromRGBO(72, 74, 98, 1),
//                                       fontSize: 15),
//                                   fontWeight: FontWeight.w500)),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                     Container(
//                       height: 305.9,
//                       decoration: BoxDecoration(
//                         color: const Color.fromRGBO(255, 255, 255, 1),
//                         borderRadius: BorderRadius.circular(10),
//                         boxShadow: const [
//                           BoxShadow(
//                               color: Color.fromARGB(40, 0, 0, 0), //New
//                               blurRadius: 24.0,
//                               offset: Offset(0, 10))
//                         ],
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(35.0),
//                         child: Column(
//                           children: [
//                             Row(
//                               children: [
//                                 Container(
//                                   width: 35,
//                                   height: 35,
//                                   decoration: const BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: Colors.blue,
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   width: 10,
//                                 ),
//                                 DropdownButton<String>(
//                                   value: selectedItem1,
//                                   underline: Container(),
//                                   onChanged: (String? newValue) {
//                                     setState(() {
//                                       selectedItem1 = newValue!;
//                                     });
//                                   },
//                                   items: _dropdownItems
//                                       .map<DropdownMenuItem<String>>(
//                                           (String value) {
//                                     return DropdownMenuItem<String>(
//                                       value: value,
//                                       child: Text(value),
//                                     );
//                                   }).toList(),
//                                 ),
//                               ],
//                             ),
//                             Container(
//                               alignment: Alignment.topLeft,
//                               child: const Text(
//                                 '1 USD = 14,860.78 IDR',
//                                 style: TextStyle(
//                                     fontSize: 13.0,
//                                     fontWeight: FontWeight.w400,
//                                     color: Color.fromRGBO(72, 74, 98, 1)),
//                               ),
//                             ),
//                             Container(
//                               alignment: Alignment.topLeft,
//                               child: const Text(
//                                 '2,780',
//                                 style: TextStyle(
//                                     fontSize: 30.0,
//                                     fontWeight: FontWeight.w300,
//                                     color: Color.fromRGBO(72, 74, 98, 1)),
//                               ),
//                             ),
//                             const SizedBox(height: 10),
//                             Container(
//                               width: 400,
//                               height: 1,
//                               decoration: const BoxDecoration(
//                                 color: Color.fromRGBO(216, 216, 216, 1),
//                               ),
//                             ),
//                             const SizedBox(height: 10),
//                             Row(
//                               children: [
//                                 Container(
//                                   width: 35,
//                                   height: 35,
//                                   decoration: const BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: Colors.blue,
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   width: 10,
//                                 ),
//                                 DropdownButton<String>(
//                                   value: selectedItem2,
//                                   underline: Container(),
//                                   onChanged: (String? newValue) {
//                                     setState(() {
//                                       selectedItem2 = newValue!;
//                                     });
//                                   },
//                                   items: _dropdownItems
//                                       .map<DropdownMenuItem<String>>(
//                                           (String value) {
//                                     return DropdownMenuItem<String>(
//                                       value: value,
//                                       child: Text(value),
//                                     );
//                                   }).toList(),
//                                 ),
//                               ],
//                             ),
//                             Container(
//                               alignment: Alignment.topLeft,
//                               child: const Text(
//                                 '1 IDR = 0.0000685403 USD',
//                                 style: TextStyle(
//                                     fontSize: 13.0,
//                                     fontWeight: FontWeight.w400,
//                                     color: Color.fromRGBO(72, 74, 98, 1)),
//                               ),
//                             ),
//                             Container(
//                               alignment: Alignment.topLeft,
//                               child: const Text(
//                                 '40,851,855.3',
//                                 style: TextStyle(
//                                     fontSize: 30.0,
//                                     fontWeight: FontWeight.w300,
//                                     color: Color.fromRGBO(72, 74, 98, 1)),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             } else {
//               return Text('hola ${snapshot.error}');
//             }
//             return const CircularProgressIndicator();
//           },
//         ),
//       ),
//     );
//   }
// }
