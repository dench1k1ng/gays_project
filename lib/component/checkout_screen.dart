import 'package:flutter/material.dart';

class CheckoutScreen extends StatelessWidget {
  // Function to show the Snackbar after successful checkout
  void showThankYouSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Thank you for your payment!'),
        duration: const Duration(
            seconds: 3), // Duration for how long the Snackbar will be visible
        backgroundColor: Colors.green, // Customize background color of Snackbar
        behavior: SnackBarBehavior
            .floating, // Optional: makes the Snackbar float above the content
      ),
    );
  }

  // Simulate checkout action
  void proceedToCheckout(BuildContext context) {
    // Add your actual payment processing logic here

    // After successful payment, show the Snackbar
    showThankYouSnackbar(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            proceedToCheckout(
                context); // Proceed with checkout and show the Snackbar
          },
          child: const Text('Proceed to Payment'),
        ),
      ),
    );
  }
}
