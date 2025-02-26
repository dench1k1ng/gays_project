import 'package:flutter/material.dart';
import 'package:food_save/auth/auth_service.dart';
import 'package:food_save/pages/basket_screen.dart';
import 'package:food_save/pages/onboarding_page.dart';
import 'package:food_save/pages/profile_page.dart';
import 'package:food_save/pages/search_page.dart';

int hexToInteger(String hex) => int.parse(hex, radix: 16);

int getBasketCount(Map<String, int> selectedItems) {
  return selectedItems.values.fold(0, (sum, quantity) => sum + quantity);
}

extension StringColorExtensions on String {
  Color toColor() => Color(hexToInteger(this));
}

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int myIndex = 0;

  // Define the items available in the app
  final List<Map<String, dynamic>> items = [
    {'image': 'assets/item1.png', 'title': 'Milk', 'price': 2.5},
    {'image': 'assets/item2.png', 'title': 'Bread', 'price': 1.2},
    // Add more items as needed
  ];

  // Define the selected items
  final Map<String, int> selectedItems = {};

  // Define the list of screens
  late final List<Widget> widgetList;

  @override
  void initState() {
    super.initState();
    widgetList = [
      OnboardingPage(),
      BasketScreen(
        selectedItems: selectedItems,
        items: items,
      ),
      ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IndexedStack(
          children: widgetList,
          index: myIndex,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        showUnselectedLabels: false,
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
        },
        currentIndex: myIndex,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            label: '',
            icon: Icon(
              Icons.home,
              color: Color(hexToInteger('FF154314')),
            ),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            label: '',
            icon: Stack(
              children: [
                Icon(
                  Icons.shopping_basket,
                  color: Color(hexToInteger('FF154314')),
                ),
                if (getBasketCount(selectedItems) >
                    0) // Show badge if items are selected
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${getBasketCount(selectedItems)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            backgroundColor: Colors.white,
            icon: Icon(
              Icons.person,
              color: Color(hexToInteger('FF154314')),
            ),
          ),
        ],
      ),
    );
  }
}
