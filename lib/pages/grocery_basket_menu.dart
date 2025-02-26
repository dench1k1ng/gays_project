// import 'package:flutter/material.dart';
// import 'basket_screen.dart';
//
// class GroceryBasketMenu extends StatelessWidget {
//   final String title;
//
//   final List<Map<String, String>> groceryItems = [
//     {"image": "images/apples.jpg", "title": "Apples"},
//     {"image": "images/milk.jpg", "title": "Milk"},
//     {"image": "images/bread.jpg", "title": "Bread"},
//     {"image": "images/eggs.jpg", "title": "Eggs"},
//   ];
//   GroceryBasketMenu({Key? key, required this.title}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Grocery"),
//       ),
//       body: ListView.builder(
//         itemCount: groceryItems.length,
//         itemBuilder: (context, index) {
//           return Card(
//             margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//             child: ListTile(
//               leading: Image.asset(
//                 groceryItems[index]["image"]!,
//                 width: 60,
//                 height: 60,
//                 fit: BoxFit.cover,
//               ),
//               title: Text(groceryItems[index]["title"]!),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => BasketScreen(
//                       title: "${groceryItems[index]['title']}'s Basket",
//                       items: [groceryItems[index]["title"]!],
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
