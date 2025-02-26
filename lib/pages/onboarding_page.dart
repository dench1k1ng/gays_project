import 'package:flutter/material.dart';
import 'package:food_save/pages/grocery_basket_menu.dart';
import 'package:food_save/pages/kafe_basket_menu.dart';

import 'menu_screen.dart';

class OnboardingPage extends StatelessWidget {
  final List<Map<String, String>> items = [
    {
      "image": "images/mcdon.png",
      "title": "McDonald's",
    },
    {
      "image": "images/magnum2.png",
      "title": "Magnum",
    },
    {
      "image": "images/kfcDed.png",
      "title": "KFC",
    },
    {
      "image": "images/small.png",
      "title": "Small",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Добрый день!',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Найти продукты или блюда',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // "Today's Popular" Section
              Stack(
                children: [
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                        image: AssetImage('images/fermag.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Text(
                      "ПОПУЛЯРНОЕ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 20,
                    child: Row(
                      children: [
                        DiscountTag('-50%', Colors.red),
                        const SizedBox(width: 8),
                        DiscountTag('-40%', Colors.orange),
                        const SizedBox(width: 8),
                        DiscountTag('-30%', Colors.green),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // "All" Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Все',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Все'),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // List/Grid of Items
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.9,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) => FoodItemCard(
                  imagePath: items[index]['image']!,
                  title: items[index]['title']!,
                  onTap: () {
                    // Navigate to different screens based on the item's index or type
                    if (index % 2 == 0) {
                      // Navigate to ScreenTypeA for even-index items
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MenuScreen(menuType: "Заведения"),
                        ),
                      );
                    } else {
                      // Navigate to ScreenTypeB for odd-index items
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MenuScreen(menuType: "Продукты"),
                        ),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

class DiscountTag extends StatelessWidget {
  final String label;
  final Color color;

  const DiscountTag(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}

class FoodItemCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final Function onTap;
  final bool isSelected; // Add a flag to track selection

  const FoodItemCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
        color: isSelected
            ? Colors.lightGreenAccent
            : Colors.white, // Highlight selected
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 80, fit: BoxFit.cover),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
