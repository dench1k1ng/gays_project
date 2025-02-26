// import 'package:flutter/material.dart';
// import 'basket_screen.dart';
//
// class KafeBasketMenu extends StatelessWidget {
//   final String title;
//
//   final List<Map<String, String>> fastFoodItems = [
//     {"image": "images/mcdonalds.jpg", "title": "McDonald's"},
//     {"image": "images/kfc.jpg", "title": "KFC"},
//     {"image": "images/pizza_hut.jpg", "title": "Pizza Hut"},
//     {"image": "images/burger_king.jpg", "title": "Burger King"},
//   ];
//   KafeBasketMenu({Key? key, required this.title}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Fast Food"),
//       ),
//       body: ListView.builder(
//         itemCount: fastFoodItems.length,
//         itemBuilder: (context, index) {
//           return Card(
//             margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//             child: ListTile(
//               leading: Image.asset(
//                 fastFoodItems[index]["image"]!,
//                 width: 60,
//                 height: 60,
//                 fit: BoxFit.cover,
//               ),
//               title: Text(fastFoodItems[index]["title"]!),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => BasketScreen(
//                       title: "${fastFoodItems[index]['title']}'s Basket",
//                       items: [fastFoodItems[index]["title"]!],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
