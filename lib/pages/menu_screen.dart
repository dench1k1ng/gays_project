import 'package:flutter/material.dart';
import 'basket_screen.dart';

class MenuScreen extends StatefulWidget {
  final String menuType; // "Grocery" or "Cafe"

  const MenuScreen({Key? key, required this.menuType}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late List<Map<String, dynamic>> items;
  late List<Map<String, dynamic>> filteredItems; // Filtered items list

  final List<Map<String, dynamic>> cafeItems = [
    {'image': 'images/beh/combo.jpg', 'title': 'Комбо', 'price': 1500},
    {'image': 'images/beh/bulki.jpg', 'title': 'Самса', 'price': 700},
    {'image': 'images/beh/doner.jpg', 'title': 'Донер', 'price': 800},
    {'image': 'images/beh/free.jpg', 'title': 'Картошка фрии', 'price': 400},
    {'image': 'images/beh/lagman.jpg', 'title': 'Лагман', 'price': 1000},
    {'image': 'images/beh/pizza.jpg', 'title': 'Пицца', 'price': 1400},
    {'image': 'images/beh/ploov.jpg', 'title': 'Плов', 'price': 1200},
    {'image': 'images/beh/sup.jpg', 'title': 'Суп', 'price': 900},
  ];

  final List<Map<String, dynamic>> groceryItems = [
    {'image': 'images/gro/app.jpg', 'title': 'Яблоки', 'price': 300},
    {'image': 'images/gro/banana.jpg', 'title': 'Бананы', 'price': 500},
    {'image': 'images/gro/milk.jpg', 'title': 'Молоко', 'price': 450},
    {'image': 'images/gro/bread.jpg', 'title': 'Хлеб', 'price': 150},
    {'image': 'images/gro/straw.jpg', 'title': 'Клубника', 'price': 900},
    {'image': 'images/gro/cokki.jpg', 'title': 'Печеньки', 'price': 700},
  ];

  Map<String, int> selectedItems = {}; // Key: Item title, Value: Quantity

  @override
  void initState() {
    super.initState();
    // Load items based on menuType
    items = widget.menuType == "Продукты" ? groceryItems : cafeItems;
    filteredItems = items; // Initially, show all items
  }

  void toggleSelection(String title) {
    setState(() {
      if (selectedItems.containsKey(title)) {
        selectedItems.remove(title);
      } else {
        selectedItems[title] = 1; // Default quantity
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.menuType} Меню'),
      ),
      body: Column(
        children: [
          // Search TextField
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  filteredItems = items.where((item) {
                    return item['title']
                        .toLowerCase()
                        .contains(value.toLowerCase());
                  }).toList();
                });
              },
              decoration: const InputDecoration(
                labelText: 'Поиск',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // Display the filtered items in a GridView
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.9,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return FoodItemCard(
                  imagePath: item['image'],
                  title: item['title'],
                  isSelected: selectedItems.containsKey(item['title']),
                  onTap: () => toggleSelection(item['title']),
                );
              },
            ),
          ),

          // Button to go to Basket screen
          ElevatedButton(
            onPressed: selectedItems.isEmpty
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BasketScreen(
                          selectedItems: selectedItems,
                          items: items,
                        ),
                      ),
                    );
                  },
            child: const Text('Корзина'),
          ),
        ],
      ),
    );
  }
}

class FoodItemCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const FoodItemCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Image.asset(imagePath, height: 100, width: 100, fit: BoxFit.cover),
            Text(title),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Colors.green,
              )
          ],
        ),
      ),
    );
  }
}
