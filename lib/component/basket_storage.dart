// import 'package:shared_preferences/shared_preferences.dart';
//
// class BasketStorage {
//   static Future<void> saveBasket(Map<String, int> selectedItems) async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String> basketData = selectedItems.entries
//         .map((entry) => '${entry.key}:${entry.value}')
//         .toList();
//     prefs.setStringList('basket', basketData);
//   }
//
//   static Future<Map<String, int>> loadBasket() async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String>? basketData = prefs.getStringList('basket');
//     if (basketData == null) {
//       return {}; // Return empty basket if nothing is saved
//     }
//
//     Map<String, int> selectedItems = {};
//     for (var entry in basketData) {
//       var parts = entry.split(':');
//       selectedItems[parts[0]] = int.parse(parts[1]);
//     }
//
//     return selectedItems;
//   }
// }
