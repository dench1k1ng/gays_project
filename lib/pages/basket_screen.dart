import 'package:flutter/material.dart';

class BasketScreen extends StatefulWidget {
  final Map<String, int> selectedItems; // Selected items with quantities
  final List<Map<String, dynamic>> items; // List of all items (with prices)

  const BasketScreen(
      {Key? key, required this.selectedItems, required this.items})
      : super(key: key);

  @override
  _BasketScreenState createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen> {
  @override
  Widget build(BuildContext context) {
    double totalPrice = 0;

    // Calculate the total price of all selected items
    widget.selectedItems.forEach((title, quantity) {
      final item = widget.items.firstWhere((item) => item['title'] == title);
      totalPrice += item['price'] * quantity;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Корзина'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.selectedItems.length,
              itemBuilder: (context, index) {
                final itemTitle = widget.selectedItems.keys.elementAt(index);
                final quantity = widget.selectedItems[itemTitle];

                // Find the item details from the items list
                final item = widget.items
                    .firstWhere((item) => item['title'] == itemTitle);

                return ListTile(
                  leading: Image.asset(item['image'], width: 50, height: 50),
                  title: Text(item['title']),
                  subtitle: Text('Цена: ${item['price']} тенге'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Quantity controlge
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (quantity! > 1) {
                              widget.selectedItems[itemTitle] = quantity - 1;
                            }
                          });
                        },
                      ),
                      Text('$quantity'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            widget.selectedItems[itemTitle] = (quantity! + 1)!;
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Show total price
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Всего: ${totalPrice.toStringAsFixed(2)} тенге',
                style: const TextStyle(fontSize: 24)),
          ),
          // Proceed to Checkout
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: widget.selectedItems.isEmpty
                  ? null
                  : () {
                      // Proceed to checkout (e.g., show a confirmation screen or perform the checkout)
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Оплатить'),
                            content: Text(
                                'Общая цена ${totalPrice.toStringAsFixed(2)} тенге.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: const Text('Отмена'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Perform the checkout action here
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                  // Optionally clear the basket
                                  setState(() {
                                    widget.selectedItems.clear();
                                  });
                                },
                                child: const Text('Потвердить'),
                              ),
                            ],
                            // alertdialog
                          );
                        },
                      );
                    },
              //Потвердить оплату
              child: const Text('Потвердить оплату'),
            ),
          ),
        ],
      ),
    );
  }
}
